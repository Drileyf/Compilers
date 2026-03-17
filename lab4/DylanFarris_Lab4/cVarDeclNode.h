#pragma once

#include "cDeclNode.h"
#include "cSymbol.h"
#include "cVisitor.h"

class cVarDeclNode : public cDeclNode
{
public:
    cVarDeclNode(cSymbol *type, cSymbol *name) : cDeclNode()
    {
        AddChild(type);
        AddChild(name);
    }

    virtual std::string NodeType() { return "var_decl"; }

    virtual void Visit(cVisitor *visitor) { visitor->Visit(this); }
};
