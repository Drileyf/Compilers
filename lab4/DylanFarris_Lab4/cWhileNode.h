#pragma once

#include "cStmtNode.h"

class cWhileNode : public cStmtNode
{
public:
    cWhileNode(cExprNode *expr, cStmtNode *stmt) : cStmtNode()
    {
        AddChild(expr);
        AddChild(stmt);
    }

    virtual std::string NodeType() { return "while"; }
};
