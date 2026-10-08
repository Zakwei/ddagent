import 'package:ddagent_app/core/utils/path_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pathBasename handles both separators', () {
    expect(pathBasename('/home/u/proj/a.txt'), 'a.txt');
    expect(pathBasename(r'C:\Users\u\proj\a.txt'), 'a.txt');
    expect(pathBasename(r'C:/Users\u/a.txt'), 'a.txt');
    expect(pathBasename('/home/u/proj/'), 'proj');
    expect(pathBasename(r'C:\proj\'), 'proj');
    expect(pathBasename('a.txt'), 'a.txt');
  });

  test('pathDirname keeps the original separator style', () {
    expect(pathDirname(r'C:\a\b.txt'), r'C:\a');
    expect(pathDirname(r'C:\a'), 'C:');
    expect(pathDirname('C:'), '');
    expect(pathDirname('/a/b.txt'), '/a');
    expect(pathDirname('/a'), '/');
    expect(pathDirname('a.txt'), '');
  });
}
