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
      expect(removePaneFromLayout(const PaneLeaf('a'), 'a'), isNull);
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
        const [PaneLeaf('a'), PaneLeaf('gone'), PaneLeaf('a')],
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
}
