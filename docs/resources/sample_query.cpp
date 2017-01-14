QbMySQLQuery query = QbMySQLQuery(Employee::CLASSNAME);
query.appendWhere(Employee::FIRSTNAME, "Ryo", QbQuery::EQUALS);
query.appendAnd();
query.appendWhere(Employee::SALARY, "150", QbQuery::MORE_THAN);
list = QbDatabase::getInstance()->load(&query);