/*
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

#ifndef FULLHIST_H
#define FULLHIST_H

#include "Edge.h"
#include <list>
#include "Wrd.h"
#include <iostream>
#include <fstream>
#include "ECString.h"

class FullHist;
class Bchart;
typedef list<FullHist*>::iterator FullHistIter;

class
FullHist
{
public:
  FullHist() : cpos(0), e(NULL), back(NULL),hd(NULL),cb(NULL) {}
    FullHist(Edge* e1) : cpos(0), e(e1), back(NULL),cb(NULL){}
  FullHist(int tint, Bchart* cb)
    : cpos(0), term(tint), back(NULL), pos(-1), hd(NULL), cb(cb){}
  FullHist(int tint, FullHist* fh, Item* i)
    : cpos(0), itm(i), term(tint), back(fh), pos(-1),hd(NULL),cb(fh->cb){}
  FullHist* extendByEdge(Edge* e1);
  FullHist* extendBySubConstit();
  FullHist* retractByEdge();
  FullHist* nth(int n)
    {
      if(n < 0 || n >= size) return NULL;
      else return fharray[n];
    }
  friend ostream& operator<<(ostream& os, const FullHist& fh);
  int cpos;
  Edge* e;
  Item* itm;
  int term;
  FullHist* back;
  int pos;
  const Wrd* hd;
  Bchart* cb;
  int hpos;
  int preTerm;
  FullHist* fharray[400];
  int size;
};

#endif
