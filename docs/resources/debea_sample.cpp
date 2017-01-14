ar.open("dbasqlite3-static", "dbname=foobasefile.sqt3");
ar.getOStream().sendUpdate(counter_create);
ar.getOStream().sendUpdate(foo_create);
Foo c1;
c1.mIntVal = 12;
c1.mStrVal = "test string";
dba::SQLOStream ostream = ar.getOStream();
ostream.open();
ostream.put(&c1);
std::cout << "Foo c1 was stored with id = " << c1.getId() << std::endl;
ostream.destroy();
Foo c2;
dba::SQLIStream istream = ar.getIStream();
istream.open(c2);
while (istream.getNext(&c2)) {
    std::cout << "readed Foo c2 with id: " << c2.getId() << std::endl;
};
if ((c1.mIntVal == c2.mIntVal) && (c1.mStrVal == c2.mStrVal))
    std::cerr << "Foo is Foo!" << std::endl;