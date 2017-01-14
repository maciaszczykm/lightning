#include "precompiled.h"
#include "drug.h"
#include <QxMemLeak.h>

int main(int argc, char * argv[])
{
   QApplication app(argc, argv);
   typedef boost::shared_ptr<drug> drug_ptr;
   drug_ptr d1; d1.reset(new drug()); d1->name = "name1"; d1->description = "desc1";
   drug_ptr d2; d2.reset(new drug()); d2->name = "name2"; d2->description = "desc2";
   drug_ptr d3; d3.reset(new drug()); d3->name = "name3"; d3->description = "desc3";
   typedef std::vector<drug_ptr> type_lst_drug;
   type_lst_drug lst_drug;
   lst_drug.push_back(d1);
   lst_drug.push_back(d2);
   lst_drug.push_back(d3);
   qx::QxSqlDatabase::getSingleton()->setDriverName("QSQLITE");
   qx::QxSqlDatabase::getSingleton()->setDatabaseName("./test_qxorm.db");
   qx::QxSqlDatabase::getSingleton()->setHostName("localhost");
   qx::QxSqlDatabase::getSingleton()->setUserName("root");
   qx::QxSqlDatabase::getSingleton()->setPassword("");
   QSqlError daoError = qx::dao::create_table<drug>();
   daoError = qx::dao::insert(lst_drug);
   d2->name = "name2 modified";
   d2->description = "desc2 modified";
   daoError = qx::dao::update(d2);
   daoError = qx::dao::delete_by_id(d1);
   long lDrugCount = qx::dao::count<drug>();
   drug_ptr d_tmp; d_tmp.reset(new drug());
   d_tmp->id = 3;
   daoError = qx::dao::fetch_by_id(d_tmp);
   qx::serialization::xml::to_file(lst_drug, "./export_drugs.xml");
   type_lst_drug lst_drug_tmp;
   qx::serialization::xml::from_file(lst_drug_tmp, "./export_drugs.xml");
   drug_ptr d_clone = qx::clone(* d1);
   boost::any d_any = qx::create("drug");
   qx::cache::set("drugs", lst_drug);
   qx::cache::clear();
   drug * pDummy = new drug();
   return 0;
}