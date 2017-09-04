/*
 * Copyright 1999, 2005 Brown University, Providence, RI.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License.  You may obtain
 * a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

#ifndef FEATTREEITER_H
#define FEATTREEITER_H

#include "FeatureTree.h"

class FeatTreeIter
{
public:
  FeatTreeIter(FeatureTree* ft) : currDepth(0), alive_(1), curr(ft)
    {
      maps[0] = ft->subtree.begin();
      next();
    }
  void next();
  int alive() { return alive_; }
  FeatureTree* curr;
  int depth() const { return currDepth; }
private:
  FTreeMap::iterator maps[15];
  int currDepth;
  int alive_;
};

#endif /* ! FEATTREEITER_H */
