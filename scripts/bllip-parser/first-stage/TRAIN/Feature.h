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

#ifndef FEATUREFUNCTION_H
#define FEATUREFUNCTION_H

#include "ECString.h"
#include <list>
#include <assert.h>

#define MAXNUMFS 35

//JT added from prev version
#define NUMCALCS 11

#define MAXNUMCALCS 12
#define MAXNUMNTS 200
#define MAXNUMNTTS 200
#define MAXNUMTS 200

#define RCALC 0
#define HCALC 1
#define UCALC 2
#define MCALC 3
#define LCALC 4
#define LMCALC 5
#define RUCALC 6
#define RMCALC 7
#define TTCALC 8

//JT added SCALC
#define SCALC 9
#define WWCALC 10

#define AUXIND -9
#define ROOTIND -99

class TreeHist;

class FTypeTree;

class FTypeTree
{
 public:
  FTypeTree() : back(NULL),left(NULL), right(NULL), n(-1) {}
  FTypeTree(int fi) : back(NULL), left(NULL), right(NULL), n(fi) {}
  int n;
  FTypeTree* left;
  FTypeTree* right;
  FTypeTree* back;
};

  /*  Currently what goes in Funs.
    0 t  tree_term 0 |
    1 l  tree_parent_term
    2 u  tree_pos
    3 h  tree_head
    4 ph tree_parent_head
    */



/*
  num  name  function
  0    t      0
  1    l      1
  2    u      2
  */
class SubFeature
{
 public:
  SubFeature(int i, ECString& nm, int fnn, list<int> fl)
    : num(i), name(nm), usf(fnn), fun(Funs[fnn]), featList(fl)
    {}
  static SubFeature*& fromInt(int i, int which) { return array_[which][i]; }
  int num;
  ECString name;
  int (*fun)(TreeHist*);
  int usf;
  list<int> featList;
  static int total[MAXNUMCALCS];
  static int (*Funs[MAXNUMFS])(TreeHist*);
  static int (*PRFuns[MAXNUMCALCS])(TreeHist*);
  static int      ufArray[MAXNUMCALCS][MAXNUMFS];
  static int      splitPts[MAXNUMCALCS][MAXNUMFS];
 private:
  static SubFeature* array_[MAXNUMCALCS][MAXNUMFS];
};

/*
  num name ff startpos
  1   rt   0  0
  2   rtl  1  1
  3   rtu  2  1
  */
class Feature
{
 public:
  Feature(int i, ECString& nm, int ff, int pos, int cpr)
    : num(i), name(nm), subFeat(ff), startPos(pos), auxCnt(0),
      condPR(cpr) {}
  static Feature*& fromInt(int i, int which)
    {
      assert(i > 0);
      return array_[which][i-1];
    }
  static void assignCalc(ECString conditioned);
  int num;
  ECString name;
  int subFeat;
  int usubFeat;
  int startPos;
  int condPR;
  int auxCnt;
  static void setLM() { isLM = true; numCalcs = 10; }
  static bool isLM;
  static int numCalcs;
  static int total[MAXNUMCALCS];
  static int conditionedFeatureInt[MAXNUMCALCS];
  static void init(ECString& path, ECString& conditioned);
  static int whichInt;
  static int assumedFeatVal;
  static int (*conditionedEvent)(TreeHist*);
  static int (*assumedSubFeat)(TreeHist*);
  static FTypeTree ftTree[MAXNUMCALCS];
  static FTypeTree* ftTreeFromInt[MAXNUMCALCS][MAXNUMFS];
  static void  createFTypeTree(FTypeTree* ft, int n, int which);
  static float getLambda(int wi, int featInt, int bucketInt)
    {return lambdas_[wi][featInt-1][bucketInt];}
  static void setLambda(int wi, int featInt, int bucketInt, float val)
    { lambdas_[wi][featInt-1][bucketInt] = val;}
  static void readLam(int which, ECString tmp, ECString path);
  //JT
  static float logFacs[NUMCALCS][MAXNUMFS];

 private:
  static Feature* array_[MAXNUMCALCS][MAXNUMFS];
  static float* lambdas_[MAXNUMCALCS][MAXNUMFS];
};

#endif				/* ! FEATUREFUNCTION_H */
