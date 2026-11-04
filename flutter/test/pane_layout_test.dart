import 'package:ddagent_app/features/workspace/state/pane_layout.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic>? j(PaneLayout? l) => l?.toJson();

void main() {
  group('autoPaneLayout', () {
    test('reproduces the old grid for 1–6 panes', () {
      expect(j(autoPaneLayout(['a'])), {'pane': 'a'});
      expect(j(autoPaneLayout(['a', 'b', 'c'])), {
        'axis': 'row',
        'children': [
          {'pane': 'a'},
          {'pane': 'b'},
          {'pane': 'c'},
        ],
        'weights': [334, 333, 333],
      });
      final five = autoPaneLayout(['a', 'b', 'c', 'd', 'e'])! as PaneSplit;
      expect(five.axis, PaneAxis.column);
      expect(five.children.map(layoutLeafOrder), [
        ['a', 'b', 'c'],
        ['d', 'e'],
      ]);
      expect(autoPaneLayout(const []), isNull);
    });
  });

  group('insertPaneIntoLayout', () {
    test('beside a pane in a same-axis split it halves that pane only', () {
      final row = autoPaneLayout(['a', 'b'])!;
      expect(j(insertPaneIntoLayout(row, 'c', 'b', PaneDropZone.right)), {
        'axis': 'row',
        'children': [
          {'pane': 'a'},
          {'pane': 'b'},
          {'pane': 'c'},
        ],
        'weights': [500, 250, 250],
      });
    });

    test('across the axis it wraps the target in a new split', () {
      final row = autoPaneLayout(['a', 'b'])!;
      expect(j(insertPaneIntoLayout(row, 'c', 'a', PaneDropZone.top)), {
        'axis': 'row',
        'children': [
          {
            'axis': 'column',
            'children': [
              {'pane': 'c'},
              {'pane': 'a'},
            ],
            'weights': [500, 500],
          },
          {'pane': 'b'},
        ],
        'weights': [500, 500],
      });
    });
  });

  group('removePaneFromLayout', () {
    test('siblings take the space and single-child splits collapse', () {
      final layout = insertPaneIntoLayout(autoPaneLayout(['a', 'b']), 'c', 'a', PaneDropZone.top);
      expect(j(removePaneFromLayout(layout, 'c')), j(autoPaneLayout(['a', 'b'])));
      expect(j(removePaneFromLayout(layout, 'b')), {
        'axis': 'column',
        'children': [
          {'pane': 'c'},
          {'pane': 'a'},
        ],
        'weights': [500, 500],
      });
      expect(removePaneFromLayout(PaneLeaf('a'), 'a'), isNull);
    });
  });

  test('moving a pane out of a column back beside it flattens the tree', () {
    final stacked = movePaneInLayout(autoPaneLayout(['a', 'b']), 'b', 'a', PaneDropZone.bottom);
    expect(j(stacked), {
      'axis': 'column',
      'children': [
        {'pane': 'a'},
        {'pane': 'b'},
      ],
      'weights': [500, 500],
    });
    expect(j(movePaneInLayout(stacked, 'b', 'a', PaneDropZone.left)), {
      'axis': 'row',
      'children': [
        {'pane': 'b'},
        {'pane': 'a'},
      ],
      'weights': [500, 500],
    });
    expect(identical(movePaneInLayout(stacked, 'a', 'a', PaneDropZone.left), stacked), isTrue);
  });

  test('weights are normalized integers summing to 1000', () {
    expect(normalizeWeights([1, 1, 1]), [334, 333, 333]);
    expect(normalizeWeights([0.2, 0.8]), [200, 800]);
    expect(normalizeWeights([0, 0]), [500, 500]);
    final resized = setLayoutWeights(autoPaneLayout(['a', 'b']), const [], [123.4, 876.6]);
    expect((resized! as PaneSplit).weights, [123, 877]);
    expect(layoutSplitAt(resized, const [])?.weights, [123, 877]);
  });

  group('reconcileLayout', () {
    test('drops unknown and duplicate leaves, appends missing panes', () {
      final layout = PaneSplit(
        PaneAxis.row,
        [PaneLeaf('a'), PaneLeaf('gone'), PaneLeaf('a')],
        const [1, 1, 1],
      );
      final next = reconcileLayout(layout, ['a', 'b']);
      expect(layoutLeafOrder(next), ['a', 'b']);
      expect(reconcileLayout(null, ['a']), isNull, reason: 'null stays the auto grid');
    });
  });

  group('PaneLayout.fromJson', () {
    test('is tolerant of malformed input', () {
      expect(PaneLayout.fromJson('nope'), isNull);
      expect(PaneLayout.fromJson({'axis': 'diagonal', 'children': <Object>[]}), isNull);
      final l = PaneLayout.fromJson({
        'axis': 'row',
        'children': [
          {'pane': 'a'},
          {'bogus': true},
          {'pane': 'b'},
        ],
        'weights': [1, 2, -5],
      });
      // An invalid weight resets the split to equal sizes.
      expect(j(l), {
        'axis': 'row',
        'children': [
          {'pane': 'a'},
          {'pane': 'b'},
        ],
        'weights': [500, 500],
      });
      // A single surviving child collapses to it.
      expect(
        j(
          PaneLayout.fromJson({
            'axis': 'column',
            'children': <Object>[
              {'pane': 'x'},
            ],
          }),
        ),
        {'pane': 'x'},
      );
    });
  });

  group('tab groups', () {
    final row = autoPaneLayout(['a', 'b'])!;

    test('a centre drop adds the pane to the group as the visible tab', () {
      final next = movePaneInLayout(autoPaneLayout(['a', 'b', 'c']), 'c', 'a', PaneDropZone.center);
      expect((next! as PaneSplit).children.map(j), [
        {
          'panes': ['a', 'c'],
          'active': 'c',
        },
        {'pane': 'b'},
      ]);
      expect(layoutLeafOrder(next), ['a', 'c', 'b']);
      // Dropping on the centre of its own group changes nothing.
      expect(identical(movePaneInLayout(next, 'c', 'a', PaneDropZone.center), next), isTrue);
    });

    test('closing the visible tab shows its neighbour; the last tab removes the group', () {
      final grouped = movePaneInLayout(
        autoPaneLayout(['a', 'b', 'c']),
        'c',
        'a',
        PaneDropZone.center,
      );
      expect(j(layoutGroupOf(removePaneFromLayout(grouped, 'c'), 'a')), {'pane': 'a'});
      final three = insertPaneIntoLayout(grouped, 'd', 'a', PaneDropZone.center);
      expect(j(layoutGroupOf(three, 'a')), {
        'panes': ['a', 'd', 'c'],
        'active': 'd',
      });
      expect(layoutGroupOf(removePaneFromLayout(three, 'd'), 'a')!.activeId, 'c');
    });

    test('a tab dragged to its own group\'s edge splits out of it', () {
      final grouped = insertPaneIntoLayout(row, 'c', 'a', PaneDropZone.center);
      final split = movePaneInLayout(grouped, 'c', 'a', PaneDropZone.bottom);
      expect(j(split), {
        'axis': 'row',
        'children': [
          {
            'axis': 'column',
            'children': [
              {'pane': 'a'},
              {'pane': 'c'},
            ],
            'weights': [500, 500],
          },
          {'pane': 'b'},
        ],
        'weights': [500, 500],
      });
    });

    test('activating a tab and swapping panes keep the groups', () {
      final grouped = insertPaneIntoLayout(row, 'c', 'a', PaneDropZone.center);
      expect(layoutGroupOf(setActivePaneInLayout(grouped, 'a'), 'a')!.activeId, 'a');
      final swapped = swapPanesInLayout(grouped, 'c', 'b');
      expect(j(swapped), {
        'axis': 'row',
        'children': [
          {
            'panes': ['a', 'b'],
            'active': 'b',
          },
          {'pane': 'c'},
        ],
        'weights': [500, 500],
      });
    });

    test('groups round-trip through JSON and are reconciled', () {
      final grouped = insertPaneIntoLayout(row, 'c', 'a', PaneDropZone.center);
      expect(j(PaneLayout.fromJson(grouped.toJson())), j(grouped));
      expect(
        j(
          PaneLayout.fromJson({
            'panes': ['x', 'y', 'x'],
            'active': 'zzz',
          }),
        ),
        {
          'panes': ['x', 'y'],
          'active': 'x',
        },
      );
      expect(j(layoutGroupOf(reconcileLayout(grouped, ['a', 'b']), 'a')), {'pane': 'a'});
    });
  });

  group('dockPaneAtRoot', () {
    test('a pane dropped on a workspace edge takes a full-height third', () {
      final layout = autoPaneLayout(['a', 'b', 'c', 'd']);
      final next = dockPaneAtRoot(layout, 'd', PaneDropZone.right)! as PaneSplit;
      expect(next.axis, PaneAxis.row);
      expect(j(next.children.last), {'pane': 'd'});
      expect(next.weights, [667, 333]);
      final top = dockPaneAtRoot(layout, 'a', PaneDropZone.top)! as PaneSplit;
      expect(top.axis, PaneAxis.column);
      expect(j(top.children.first), {'pane': 'a'});
    });
  });
}
