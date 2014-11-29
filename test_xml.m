addpath('xml_io_tools')
MyTree=[];
MyTree.MyNumber = 13;
MyTree.MyString = 'Hello World';
MyTree.a(1).b = 'jack';
MyTree.a(2).b = 'john';
MyTree.ATTRIBUTE.Num = 2;
MyTree.MyString.CONTENT = 'Hello World'; % simple case
MyTree.MyString.ATTRIBUTE.Num = 2;
MyTree.COMMENT = 'This is a comment';

MyTree.k = {'jack', 'john'};

MyTree.o{1}.b = 'jack';
MyTree.o{2}.b = [];
MyTree.o{2}.c = 'john';

wPref.StructItem = false;
wPref.CellItem = false;

Pref=[]; 
Pref.StructItem = false;
Pref.CellItem = false;
Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test.xml', MyTree, 'MyTree', Pref);

%xml_write('test.xml', MyTree, 'MyTree',wPref);
type('test.xml')


