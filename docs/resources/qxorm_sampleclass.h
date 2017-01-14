#ifndef _CLASS_DRUG_H_
#define _CLASS_DRUG_H_

class drug
{
public:
   long id;
   QString name;
   QString description;
   drug() : id(0) { ; }
   virtual ~drug() { ; }
};

QX_REGISTER_HPP_MY_TEST_EXE(drug, qx::trait::no_base_class_defined, 1)

#endif // _CLASS_DRUG_H_