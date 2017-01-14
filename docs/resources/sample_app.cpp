#include <QCoreApplication>
#include <QbCore/qbdatabase.h>
#include <QbCore/qbpersistable.h>
#include <QbCore/qbmysqlquery.h>
#include <QbTest/employee.h>
#include <QbTest/company.h>
#include <QbTest/assignment.h>
#include <QbTest/department.h>
#include <QsLog/QsLog.h>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    //storing objects in database
    Company company1 ("Google");
    QDate birthday(1995, 5, 17);
    QDateTime hiredate = QDateTime::currentDateTime();
    Employee employee1 (birthday, "Lee", "Jones", "M", &company1, hiredate, 2790.5, 2);
    Employee employee2 (birthday, "Joe", "Smith", "M", &company1, hiredate, 2290.5, 0);
    QbDatabase::getInstance()->store(employee1);
    QbDatabase::getInstance()->store(employee2);

    //updating objects in database
    Company company2 ("Facebook");
    employee2.setFirstname("Ryo");
    employee2.setCompanyPtr(&company2);
    QbDatabase::getInstance()->update(employee2);

    //loading objects from database
    qDebug() << "Loaded objects:\n";
    Employee empty;
    QList<QbPersistable*> list = QbDatabase::getInstance()->load(empty);
    for(int i=0; i<list.size(); i++)
    {
        Employee* loaded = (Employee*) list.at(i);
        qDebug() << loaded->getID() << "\t" << loaded->getFirstname() << "\t" << loaded->getLastname() << "\t" << loaded->getCompanyPtr()->getCompanyname()
                 << "\t" << loaded->getSalary();
    }
    if(list.size() == 0) qDebug() << "-";

    //query database
    qDebug() << "\nQuery result:\n";
    QbMySQLQuery query = QbMySQLQuery(Employee::CLASSNAME);
    query.appendWhere(Employee::FIRSTNAME, "Ryo", QbQuery::EQUALS);
    query.appendAnd();
    query.appendWhere(Employee::SALARY, "1500", QbQuery::MORE_THAN);
    list = QbDatabase::getInstance()->load(&query);
    for(int i=0; i<list.size(); i++)
    {
        Employee* loaded = (Employee*) list.at(i);
        qDebug() << loaded->getID() << "\t" << loaded->getFirstname() << "\t" << loaded->getLastname() << "\t" << loaded->getCompanyPtr()->getCompanyname()
                 << "\t" << loaded->getSalary();
    }
    if(list.size() == 0) qDebug() << "-";

    //advanced query (one to many)
    qDebug() << "\nAdvanced query result:\n";
    list = company1.getEmployees();
    for(int i=0; i<list.size(); i++)
    {
        Employee* loaded = (Employee*) list.at(i);
        qDebug() << loaded->getID() << "\t" << loaded->getFirstname() << "\t" << loaded->getLastname() << "\t" << loaded->getCompanyPtr()->getCompanyname()
                 << "\t" << loaded->getSalary();
    }
    if(list.size() == 0) qDebug() << "-";

    //storing new objects in database
    Department department1 ("Human Resources");
    Department department2 ("Board");
    Assignment assignment1 (&department1, &employee1);
    Assignment assignment2 (&department2, &employee2);
    QbDatabase::getInstance()->store(department1);
    QbDatabase::getInstance()->store(department2);
    QbDatabase::getInstance()->store(assignment1);
    QbDatabase::getInstance()->store(assignment2);

    //advanced query (many to many)
    qDebug() << "\nAdvanced query result:\n";
    list = employee1.getDepartments();
    for(int i=0; i<list.size(); i++)
    {
        Department* loaded = (Department*) list.at(i);
        qDebug() << loaded->getID() << "\t" << loaded->getDepartmentname();
    }
    if(list.size() == 0) qDebug() << "-";

    //advanced query (many to many)
    qDebug() << "\nAdvanced query result:\n";
    list = department2.getEmployees();
    for(int i=0; i<list.size(); i++)
    {
        Employee* loaded = (Employee*) list.at(i);
        qDebug() << loaded->getID() << "\t" << loaded->getFirstname() << "\t" << loaded->getLastname() << "\t" << loaded->getCompanyPtr()->getCompanyname()
                 << "\t" << loaded->getSalary();
    }
    if(list.size() == 0) qDebug() << "-";

    //loading list of currently synchronized objects
    qDebug() << "\nSynchronized objects:\n";
    list = *(QbDatabase::getInstance()->getSynchronizedObjects());
    for(int i=0; i<list.size(); i++)
    {
        QbPersistable* synchronized = list.at(i);
        qDebug() << synchronized->getObjectUpperName() + ":" + QString::number(synchronized->getID());
    }
    if(list.size() == 0) qDebug() << "-";

    //removing objects from database
    QbDatabase::getInstance()->remove(assignment1);
    QbDatabase::getInstance()->remove(assignment2);
    QbDatabase::getInstance()->remove(employee1);
    QbDatabase::getInstance()->remove(employee2);
    QbDatabase::getInstance()->remove(company1);
    QbDatabase::getInstance()->remove(company2);
    QbDatabase::getInstance()->remove(department1);
    QbDatabase::getInstance()->remove(department2);

    //loading list of currently synchronized objects
    qDebug() << "\nSynchronized objects:\n";
    list = *(QbDatabase::getInstance()->getSynchronizedObjects());
    for(int i=0; i<list.size(); i++)
    {
        QbPersistable* synchronized = list.at(i);
        qDebug() << synchronized->getObjectUpperName() + ":" + QString::number(synchronized->getID());
    }
    if(list.size() == 0) qDebug() << "-";

    //closing database connection to prevent application crash
    QbDatabase::deleteInstance();

    return app.exec();
}
