#pragma once

#include "cStmtNode.h"

class cIfNode : public cStmtNode
{
public:
    cIfNode(cExprNode *expr, cStmtsNode *ifstmts, cStmtsNode *elsestmts) : cStmtNode()
    {
        AddChild(expr);
        AddChild(ifstmts);

        if (elsestmts != nullptr)
            AddChild(elsestmts);
    }

    virtual std::string NodeType() { return "if"; }
};
