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

#ifndef BST_H
#define BST_H

#include "Edge.h"
#include <vector>
#include "ValHeap.h"
#include "CntxArray.h"
#include "ECString.h"
#include <iostream>

#define NORMALVAL 0
#define TERMINALVAL 1
#define EXTRAVAL 2
class Bst;

typedef list<Bst*> Bsts;
typedef vector<short> shorts;
typedef shorts::iterator shortIter;

class Val
{
 public:
  static Val* newIth(int ith, Val* oval, bool& stop);
  Val() : status(NORMALVAL), len_(1), prob_(0), edge_(NULL), trm_(-1), wrd_(-1)
    {
      vec_.push_back(0);
    }
  Val(Edge* e, double prb);
  ~Val();
  Edge* edge() const { return edge_; }
  Bsts& bsts() { return bsts_; }
  short  len() const { return len_; }
  short& len() { return len_; }
  short trm() const;
  short& trm1() { return trm_; }
  int wrd() const;
  int& wrd1() { return wrd_; }
  vector<short>& vec() { return vec_; }
  vector<short> vec() const { return vec_; }
  short&  vec(int i) { return vec_[i]; }
  double prob() const { return prob_; }
  double& prob() { return prob_; }
  double fom() { return prob_; }
  void  extendTrees(Bst& bst2,int pos); 
  friend ostream& operator<<(ostream& os, const Val& v);
  friend bool operator==(Val& v1, Val& v2);
  bool check();
  short status;
 private:
  Val(Val* oval);
  short len_;
  double prob_;
  Edge*  edge_;
  short trm_;
  int   wrd_;
  Bsts bsts_;
  vector<short> vec_;
};

class Bst
{
 public:
  Bst() : explored_(false), done_(false), num_(0), sum_(0) {}
  ~Bst();
  Val* next(int n);
  bool explored() const { return explored_; }
  bool& explored() { return explored_; }
  Val* nth(int i) { return nbest[i]; }
  int num() const { return num_; }
  int& num() { return num_; }
  bool empty() { return num_ == 0; }
  double prob() { return num_ == 0 ? 0 : nbest[0]->prob(); }
  double sum() const { return sum_; }
  double& sum() { return sum_; }
  ValHeap heap;
  void push(Val* val) { heap.push(val); }
  Val* pop() { return heap.pop(); }
  void addnth(Val* val)
    {
      num_++;
      nbest.push_back(val);
    }
  static void tester(Val* val);
  bool ptst(Val* val);
 private:
  bool explored_;
  bool done_;
  int num_;
  double sum_;
  vector<Val*> nbest;
};

typedef map<CntxArray, Bst, less<CntxArray> > BstMap;
Bst& bstFind(CntxArray& hi, BstMap& bm);
Bst&  ithBst(int i, Bsts& bsts);

#endif /* ! BST_H */
