# SPDX-License-Identifier: GPL-2.0-or-later
# ToolsForCategoricalTowers: Tools for CategoricalTowers
#
# Implementations
#

##
@InstallMethod( PreCompose,
        "for a julia object",
        [ IsJuliaObject ],
        
  function( L )
    
    return PreComposeList( ConvertJuliaToGAP( L ) );
    
end );

##
@InstallMethod( PreComposeList,
        "for a julia object",
        [ IsJuliaObject ],
        
  function( L )
    
    return PreComposeList( ConvertJuliaToGAP( L ) );
    
end );

##
@InstallMethod( CanCompute,
        "for a julia object",
        [ IsCapCategory, IsJuliaObject ],
        
  function( C, oper )
    
    return CanCompute( C, ConvertJuliaToGAP( oper ) );
    
end );

##
@InstallMethod( ProjectionInFactorOfFiberProduct,
        "for a julia object and an integer",
        [ IsJuliaObject, IsInt ],
        
  function( D, k )
    
    return ProjectionInFactorOfFiberProduct( ConvertJuliaToGAP( D ), k );
    
end );

##
@InstallMethod( UniversalMorphismIntoFiberProduct,
        "for two julia objects",
        [ IsJuliaObject, IsJuliaObject ],
        
  function( D, tau )
    
    return UniversalMorphismIntoFiberProduct( ConvertJuliaToGAP( D ), ConvertJuliaToGAP( tau ) );
    
end );

##
@InstallMethod( MorphismFromFiberProductToSink,
        "for a julia object",
        [ IsJuliaObject ],
        
  function( D )
    
    return MorphismFromFiberProductToSink( ConvertJuliaToGAP( D ) );
    
end );

##
@InstallMethod( InjectionOfCofactorOfPushout,
        "for a julia object and an integer",
        [ IsJuliaObject, IsInt ],
        
  function( D, k )
    
    return InjectionOfCofactorOfPushout( ConvertJuliaToGAP( D ), k );
    
end );

##
@InstallMethod( UniversalMorphismFromPushout,
        "for two julia objects",
        [ IsJuliaObject, IsJuliaObject ],
        
  function( D, tau )
    
    return UniversalMorphismFromPushout( ConvertJuliaToGAP( D ), ConvertJuliaToGAP( tau ) );
    
end );

##
@InstallMethod( MorphismFromSourceToPushout,
        "for a julia object",
        [ IsJuliaObject ],
        
  function( D )
    
    return MorphismFromSourceToPushout( ConvertJuliaToGAP( D ) );
    
end );

##
@InstallMethod( Limit,
        "for a julia object",
        [ IsJuliaObject, IsJuliaObject ],
        
  function( D1, D2 )
    
    return Limit( ConvertJuliaToGAP( D1 ), ConvertJuliaToGAP( D2 ) );
    
end );

##
@InstallMethod( Colimit,
        "for a julia object",
        [ IsJuliaObject, IsJuliaObject ],
        
  function( D1, D2 )
    
    return Colimit( ConvertJuliaToGAP( D1 ), ConvertJuliaToGAP( D2 ) );
    
end );
