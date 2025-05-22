# SPDX-License-Identifier: GPL-2.0-or-later
# ToolsForCategoricalTowers: Tools for CategoricalTowers
#
# Implementations
#

##
@InstallGlobalFunction( DigraphOfKnownDoctrines,
  function( )
    local compare, D, doctrines, positions;
    
    compare =
      function( a, b )
        local bool;
        
        bool = IsSubset( ListOfDefiningOperations( a ), ListOfDefiningOperations( b ) );
        
        if (IsBoundGlobal( a ))
            return ( b in ListImpliedFilters( ValueGlobal( a ) ) ) || bool;
        else
            return bool;
        end;
        
    end;
    
    D = Digraph( SetGAP( RecNames( CAP_INTERNAL_CONSTRUCTIVE_CATEGORIES_RECORD ) ), compare );
    
    doctrines = ShallowCopy( D.vertexlabels );
    
    positions = List( DigraphStronglyConnectedComponents(D).comps, Last );
    
    D = DigraphReflexiveTransitiveReduction( InducedSubdigraph( D, positions ) );
    
    SetFilterObj( D, IsDigraphOfDoctrines );
    
    return D;
    
end );

##
@InstallGlobalFunction( ListKnownDoctrines,
  function( )
    local D;
    
    D = DigraphOfKnownDoctrines( );
    
    return D.vertexlabels[DigraphTopologicalSort( D )];
    
end );

##
@InstallMethod( DotVertexLabelledDigraph,
        "for a digraph of doctirnes",
        [ IsDigraphByOutNeighboursRep && IsDigraphOfDoctrines ],
        
  function( D )
    local str, i, j, out, l;
    
    # Copied from DotVertexLabeledDigraph() at Digraphs/gap/display.gi
    str = "//dot\n";
    
    Append( str, "digraph doctrines[\n" );
    Append( str, "rankdir=LR\n" );
    Append( str, "node [shape=rect fontsize=12]\n" );
    
    for i in DigraphVertices( D )
        Append( str, StringGAP(i) );
        Append( str, " [label=\"" );
        Append( str, StringGAP( DigraphVertexLabel( D, i ) ) );
        Append( str, "\"]\n" );
    end;
    
    out = OutNeighbours(D);
    
    for i in DigraphVertices( D )
        l = Length( out[i] );
        for j in (1):(l)
            Append( str, @Concatenation( StringGAP(out[i][j]), " -> ", StringGAP(i), "\n" ) );
        end;
    end;
    
    Append( str, "]\n" );
    
    return str;
    
end );

##
@InstallMethod( Visualize,
        "for a digraph of doctirnes",
        [ IsDigraphByOutNeighboursRep && IsDigraphOfDoctrines ],
        
  function( D )
    
    Splash( DotVertexLabelledDigraph( D ) );
    
end );

MakeShowable( [ "image/svg+xml" ], IsDigraphByOutNeighboursRep && IsDigraphOfDoctrines );

##
@InstallMethod( SvgString,
        "for a digraph of doctirnes",
        [ IsDigraphByOutNeighboursRep && IsDigraphOfDoctrines ],
        
  function( D )
    
    return DotToSVG( DotVertexLabelledDigraph( D ) );
    
end );
