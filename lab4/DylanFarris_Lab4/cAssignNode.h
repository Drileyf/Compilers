#pragma once

#include "cStmtNode.h"
#include "cExprNode.h"

class cAssignNode : public cStmtNode
{
public:
    cAssignNode(cAstNode *lhs, cExprNode *rhs) : cStmtNode()
    {
        AddChild(lhs);
        AddChild(rhs);
    }

    virtual std::string NodeType() { return "assign"; }
};
