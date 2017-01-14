#include "precompiled.h"
#include "drug.h"
#include <QxMemLeak.h>

QX_REGISTER_CPP_MY_TEST_EXE(drug)

namespace qx {
template <> void register_class(QxClass<drug> & t)
{
  t.id(& drug::id, "id");
  t.data(& drug::name, "name", 1);
  t.data(& drug::description, "desc");
}}