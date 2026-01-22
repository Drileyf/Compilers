//****************************************************
//********************************************************
// cSymbolTable.h - Define a class for the Symbol Table
//
// Author: Dylan Farris 
//

#include <algorithm>
#include <unordered_map>
#include <list>
#include <string>
#include "cSymbol.h"

using std::string;
using std::list;
using std::unordered_map;

// NOTE: The following typedef will have to be replaced by something meaningful

typedef unordered_map<string, cSymbol*> symbolTable_t;

class cSymbolTable
{
    public:
        // Construct an empty symbol table
        cSymbolTable()
        {
            IncreaseScope();     
        }

        // Increase the scope: add a level to the nested symbol table
        // Return value is the newly created scope
        symbolTable_t  *IncreaseScope()
        {
            symbolTable_t* newScope = new symbolTable_t();  
            m_list.push_front(newScope);

            return newScope;
        }

        // Decrease the scope: remove the inner-most scope.
        // Returned value is the outer-most scope AFTER the pop.
        //
        // NOTE: do NOT clean up memory after poping the table. Parts of the
        // AST will probably contain pointers to symbols in the popped table.
        symbolTable_t  *DecreaseScope()
        {
            m_list.pop_front();
            return m_list.front();
        }

        // insert a symbol into the table
        // Assumes the symbol is not already in the table
        void Insert(cSymbol *sym)
        {
            m_list.front()->insert({sym->GetName(), sym});   
        }

        // Do a lookup in the nested table. 
        // NOTE: This starts at the inner-most scope and works its way out until
        // a match is found.
        // Return the symbol for the inner-most match. 
        // Returns nullptr if no match is found.
        cSymbol *Find(string name)
        {
            cSymbol * finder;
            for(auto it : m_list) 
            {
                symbolTable_t* temp = it;
                finder=Lookup(temp, name);
                if(finder != nullptr)
                {
                    return finder;
                }
            }
            return finder;
        }

        // Find a symbol in the inner-most scope.
        // NOTE: This ONLY searches the inner-most scope.
        // Returns nullptr if the symbol is not found.
        cSymbol *FindLocal(string name)
        {
            cSymbol * finder;
            finder=Lookup(m_list.front(), name);
            return finder;
        }

        //Looks up if symbol is in current scope
        cSymbol* Lookup(symbolTable_t* currentTable, string name)
        {
            if (auto found=currentTable->find(name); found != currentTable->end())
            {
                return found->second;
            }
            return nullptr; 
        }
    protected:
        list<symbolTable_t*> m_list;
};

// declare the global symbol table. The definition will have to be in a cpp file
extern cSymbolTable g_symbolTable;
