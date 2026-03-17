#pragma once

#include "cExprNode.h"
#include "cOpNode.h"

class cBinaryExprNode : public cExprNode
{
public:
    cBinaryExprNode(cExprNode *left, cOpNode *op, cExprNode *right) : cExprNode()
    {
        AddChild(left);
        AddChild(op);
        AddChild(right);
    }

    virtual std::string NodeType() { return "expr"; }
};
