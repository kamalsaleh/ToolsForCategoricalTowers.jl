# SPDX-License-Identifier: GPL-2.0-or-later
# ToolsForCategoricalTowers: Tools for CategoricalTowers
#
# Implementations
#

##
InstallTrueMethod( IsFiniteCategory, IsInitialCategory );

#= comment for Julia
InstallTrueMethod( IsFinite, IsFiniteCategory );
# =#

InstallTrueMethod( IsObjectFiniteCategory, IsFiniteCategory );
InstallTrueMethod( IsEquivalentToFiniteCategory, IsFiniteCategory );

##
@InstallMethod( DummyCategoryInDoctrines,
        "for a list of string",
        [ IsList ],
  
  @FunctionWithNamedArguments(
  [
    [ "name", fail ],
    [ "minimal", false ],
    [ "additional_operations", Immutable( [ ] ) ],
  ],
  function( CAP_NAMED_ARGUMENTS, doctrine_names )
    local compare, options, all_operations;
    
    if (IsEmpty( doctrine_names ))
        Error( "the list of doctrine names is empty\n" );
    #= comment for Julia
    elseif (IsStringRep( doctrine_names ))
        doctrine_names = [ doctrine_names ];
    # =#
    end;
   
    #= comment for Julia (ListKnownDoctrines depends on Digraphs)
    if (@not IsSubset( ListKnownDoctrines( ), doctrine_names ))
        Error( "the following entries are not supported doctrines: ", StringGAP( Difference( doctrine_names, ListKnownDoctrines( ) ) ), "\n" );
    end;
    # =#
    
    compare =
      function( b, a )
        local bool;
        
        bool = IsSubset( ListOfDefiningOperations( a ), ListOfDefiningOperations( b ) );
        
        if (minimal && IsBoundGlobal( a ) && IsBoundGlobal( b ))
            return IsSpecializationOfFilter( ValueGlobal( b ), ValueGlobal( a ) ) || bool;
        else
            return bool;
        end;
        
    end;
    
    doctrine_names = MaximalObjects( doctrine_names, compare );
    
    options = @rec( );
    
    if (name == fail)
      options.name = @Concatenation( "DummyCategoryInDoctrines( ", StringGAP( doctrine_names ), " )" );
    else
      options.name = name;
    end;
    
    options.properties = Difference( doctrine_names, [ "IsCapCategory" ] );
    
    options.list_of_operations_to_install =
      SetGAP( @Concatenation(
              @Concatenation( List( doctrine_names, ListOfDefiningOperations ) ),
              additional_operations,
              [ "ObjectConstructor", "ObjectDatum",
                "MorphismConstructor", "MorphismDatum",
                "IsWellDefinedForObjects", "IsWellDefinedForMorphisms" ] ) );
    
    all_operations = RecNames( CAP_INTERNAL_METHOD_NAME_RECORD );
    
    options.list_of_operations_to_install =
      @Concatenation( List( options.list_of_operations_to_install, operation_name ->
            CAP_INTERNAL_CORRESPONDING_WITH_GIVEN_OBJECTS_METHOD( operation_name, all_operations ) ) );
    
    return DummyCategory( options );
    
end ) );

##
@InstallMethod( SET_RANGE_CATEGORY_Of_HOMOMORPHISM_STRUCTURE,
        "for two CAP categories",
        [ IsCapCategory, IsCapCategory ],
        
  function( C, H )
    
    if (HasRangeCategoryOfHomomorphismStructure( C ))
        Error( "the range category of the homomorphism structure is already set for the category `C`\n" );
    end;
    
    SetRangeCategoryOfHomomorphismStructure( C, H );
    SetIsEquippedWithHomomorphismStructure( C, true );
    
    ## be sure the above assignment succeeded:
    @Assert( 0, IsIdenticalObj( H, RangeCategoryOfHomomorphismStructure( C ) ) );
    
    if (MissingOperationsForConstructivenessOfCategory( H, "IsCategoryWithDecidableLifts" ) == [ ])
        SetIsCategoryWithDecidableLifts( C, true );
        SetIsCategoryWithDecidableColifts( C, true );
    end;
    
end );

##
@InstallMethod( SetOfObjectsAsUnresolvableAttribute,
        [ IsCapCategory ],
        
  SetOfObjectsOfCategory );

#= comment for Julia
##
@InstallMethod( SetOfObjects,
        [ IsInitialCategory ],
        
  function( I )
    
    return [ ];
    
end );

##
@InstallMethod( SetOfObjects,
        [ IsCapCategory && HasOppositeCategory ],
        
  function( cat_op )
    
    return List( SetOfObjects( OppositeCategory( cat_op ) ), obj -> ObjectConstructor( cat_op, obj ) );
    
end );
# =#

##
@InstallMethod( SetOfMorphisms,
        [ IsCapCategory ],
        
  function( cat )
    
    return SetOfMorphismsOfFiniteCategory( cat );
    
end );

##
@InstallMethod( CallFuncList,
        [ IsCapFunctor, IsList ],
        
  ( F, a ) -> ApplyFunctor( F, a[ 1 ] ) );

##
@InstallMethod( CallFuncList,
        [ IsCapNaturalTransformation, IsList ],
        
  ( nat, a ) -> ApplyNaturalTransformation( nat, a[ 1 ] ) );

##
@InstallMethod( Subobject,
        "for a morphism in a category",
        [ IsCapCategoryMorphism ],
        
  function( mor )
    
    if (@not CanCompute( CapCategory( mor ), "ImageEmbedding" ))
        TryNextMethod( );
    end;
    
    return ImageEmbedding( mor );
    
end );

#= comment for Julia
##
@InstallMethod( Subobject,
        "for a morphism in a category",
        [ IsCapCategoryMorphism && IsMonomorphism ],
        
  IdFunc );
# =#

##
@InstallMethod( CovariantHomFunctorData,
        [ IsCapCategory, IsCapCategoryObject ],
        
  function ( C, o )
    local id_o, on_objs, on_mors;
    
    #% CAP_JIT_DROP_NEXT_STATEMENT
    @Assert( 0, IsIdenticalObj( C, CapCategory( o ) ) );
    
    id_o = IdentityMorphism( C, o );
    
    on_objs = obj -> HomomorphismStructureOnObjects( C, o, obj );
    on_mors = ( source, mor, range ) -> HomomorphismStructureOnMorphismsWithGivenObjects( C, source, id_o, mor, range );
    
    return PairGAP( on_objs, on_mors );
    
end );

##
@InstallMethod( CovariantHomFunctor,
        [ IsCapCategoryObject ],
        
  function ( o )
    local C, data, Hom;
    
    C = CapCategory( o );
    
    data = CovariantHomFunctorData( C, o );
    
    Hom = CapFunctor( "A covariant Hom functor", C, RangeCategoryOfHomomorphismStructure( C ) );
    
    AddObjectFunction( Hom, data[1] );
    
    AddMorphismFunction( Hom, data[2] );
    
    return Hom;
    
end );

#= comment for Julia
##
@InstallMethod( GlobalSectionFunctorData,
        [ IsCapCategory && HasRangeCategoryOfHomomorphismStructure ],
        
  function ( C )
    
    return CovariantHomFunctorData( C, TerminalObject( C ) );
    
end );

##
@InstallMethod( GlobalSectionFunctor,
        [ IsCapCategory && HasRangeCategoryOfHomomorphismStructure ],
        
  function ( C )
    local data, Hom1;
    
    data = GlobalSectionFunctorData( C );
    
    Hom1 = CapFunctor( "Global section functor", C, RangeCategoryOfHomomorphismStructure( C ) );
    
    AddObjectFunction( Hom1, data[1] );
    
    AddMorphismFunction( Hom1, data[2] );
    
    return Hom1;
    
end );
# =#

## fallback method
@InstallMethod( DatumOfCellAsEvaluatableString,
        [ IsCapCategoryObject, IsList ],
        
  function( obj, list_of_evaluatable_strings )
    local list_of_values, C, pos, datum, filter, filters;
    
    list_of_values = List( list_of_evaluatable_strings, EvalString );
    
    C = CapCategory( obj );
    
    pos = PositionsProperty( list_of_values, val ->
                   IsCapCategoryObject( val ) && IsIdenticalObj( CapCategory( val ), C ) && IsEqualForObjects( val, obj ) );
    
    if (Length( pos ) == 1)
        
        return list_of_evaluatable_strings[pos[1]];
        
    elseif (Length( pos ) > 1)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "the position of the object `obj` in `list_of_values` is not unique for obj == ", obj, "\n" );
        
    end;
    
    datum = ObjectDatum( C, obj );
    
    if (IsCapCategoryCell( datum ))
        
        return CellAsEvaluatableString( datum, list_of_evaluatable_strings );
        
    elseif (IsInt( datum ) || IsBigInt( datum ))
        
        return StringGAP( datum );
        
    else
        
        # COVERAGE_IGNORE_BLOCK_START
        
        filter = ObjectFilter( C );
        
        filters = ShallowCopy( ListImpliedFilters( filter ) );
        
        filters = Difference( filters, [ NamesFilter( filter )[1] ] );
        
        filters = MaximalObjects( filters, ( a, b ) -> a in ListImpliedFilters( ValueGlobal( b ) ) );
        
        if (IsEmpty( filters ))
            filters = [ "(generic object-filter of obj)" ];
        end;
        
        Error( "ObjectDatum( C, obj ) does not lie in any of the filters [ IsCapCategoryCell, IsInt, IsBigInt ] and you need to either\n\n",
               "add `obj` to `list_of_evaluatable_strings` or\n\n",
               "InstallMethod( DatumOfCellAsEvaluatableString, [ ", filters[1], ", IsList ], function( obj, list_of_evaluatable_strings ) ... end );\n\n" );
        
        # COVERAGE_IGNORE_BLOCK_END
        
    end;
    
end );

## fallback method
@InstallMethod( DatumOfCellAsEvaluatableString,
        [ IsCapCategoryMorphism, IsList ],
        
  function( mor, list_of_evaluatable_strings )
    local list_of_values, C, pos, filter, filters;
    
    list_of_values = List( list_of_evaluatable_strings, EvalString );
    
    C = CapCategory( mor );
    
    pos = PositionsProperty( list_of_values, val ->
                   IsCapCategoryMorphism( val ) && IsIdenticalObj( CapCategory( val ), C ) && IsEqualForMorphismsOnMor( C, val, mor ) );
    
    if (Length( pos ) == 1)
        
        return list_of_evaluatable_strings[pos[1]];
        
    elseif (Length( pos ) > 1)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "the position of the morphism `mor` in `list_of_values` is not unique for mor == ", mor, "\n" );
        
    elseif (IsCapCategoryCell( MorphismDatum( C, mor ) ))
        
        return CellAsEvaluatableString( MorphismDatum( C, mor ), list_of_evaluatable_strings );
        
    else
        
        # COVERAGE_IGNORE_BLOCK_START
        
        filter = MorphismFilter( C );
        
        filters = ShallowCopy( ListImpliedFilters( filter ) );
        
        filters = Difference( filters, [ NamesFilter( filter )[1] ] );
        
        filters = MaximalObjects( filters, ( a, b ) -> a in ListImpliedFilters( ValueGlobal( b ) ) );
        
        if (IsEmpty( filters ))
            filters = [ "(generic morphism-filter of mor)" ];
        end;
        
        Error( "IsCapCategoryCell( MorphismDatum( C, mor ) ) == false and you need to either\n\n",
               "add `mor` to `list_of_evaluatable_strings` or\n\n",
               "InstallMethod( DatumOfCellAsEvaluatableString, [ ", filters[1], ", IsList ], function( mor, list_of_evaluatable_strings ) ... end );\n\n" );
        
        # COVERAGE_IGNORE_BLOCK_END
        
    end;
    
end );

##
@InstallMethod( CellAsEvaluatableString,
        [ IsCapCategoryObject, IsList ],

  function( obj, list_of_evaluatable_strings )
    local list_of_values, C, pos, string;
    
    list_of_values = List( list_of_evaluatable_strings, EvalString );
    
    C = CapCategory( obj );
    
    pos = PositionsProperty( list_of_values, val ->
                   IsCapCategoryObject( val ) && IsIdenticalObj( CapCategory( val ), C ) && IsEqualForObjects( val, obj ) );
    
    if (Length( pos ) == 1)
        
        return list_of_evaluatable_strings[pos[1]];
        
    elseif (Length( pos ) > 1)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "the position of the object `obj` in `list_of_values` is not unique for obj == ", obj, "\n" );
        
    end;
    
    pos = PositionsProperty( list_of_values, val -> IsIdenticalObj( val, C ) );
    
    if (Length( pos ) == 0)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "could not find CapCategory( obj ) in `list_of_values` for obj == ", obj, "\n" );
        
    elseif (Length( pos ) > 1)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "the position of CapCategory( obj ) in `list_of_values` is not unique for obj == ", obj, "\n" );
        
    end;
    
    string = @Concatenation(
                      "ObjectConstructor( ", list_of_evaluatable_strings[pos[1]], ", ",
                      DatumOfCellAsEvaluatableString( obj, list_of_evaluatable_strings ), " )" );
    
    #@Assert( 0, IsEqualForObjects( obj, EvalString( string ) ) );
    
    return string;
    
end );

##
@InstallMethod( CellAsEvaluatableString,
        [ IsCapCategoryMorphism, IsList ],

  function( mor, list_of_evaluatable_strings )
    local list_of_values, C, pos, cat, string;
    
    list_of_values = List( list_of_evaluatable_strings, EvalString );
    
    C = CapCategory( mor );
    
    pos = PositionsProperty( list_of_values, val ->
                   IsCapCategoryMorphism( val ) && IsIdenticalObj( CapCategory( val ), C ) && IsEqualForMorphismsOnMor( C, val, mor ) );
    
    if (Length( pos ) == 1)
        
        return list_of_evaluatable_strings[pos[1]];
        
    elseif (Length( pos ) > 1)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "the position of the morphism `mor` in `list_of_values` is not unique for mor == ", mor, "\n" );
        
    end;
    
    pos = PositionsProperty( list_of_values, val -> IsIdenticalObj( val, C ) );
    
    if (Length( pos ) == 0)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "could not find CapCategory( mor ) in `list_of_values` for mor == ", mor, "\n" );
        
    elseif (Length( pos ) > 1)
        
        # COVERAGE_IGNORE_NEXT_LINE
        Error( "the position of CapCategory( mor ) in `list_of_values` is not unique for mor == ", mor, "\n" );
        
    end;
    
    cat = list_of_evaluatable_strings[pos[1]];
    
    if (CanCompute( C, "IsEqualToIdentityMorphism" ) && IsEqualToIdentityMorphism( mor ))
        
        string = @Concatenation(
                          "IdentityMorphism( ", cat, ", ",
                          CellAsEvaluatableString( Source( mor ), list_of_evaluatable_strings ),
                          " )" );
        
    elseif (CanCompute( C, "IsEqualToZeroMorphism" ) && IsEqualToZeroMorphism( mor ))
        
        string = @Concatenation(
                          "ZeroMorphism( ", cat, ", ",
                          CellAsEvaluatableString( Source( mor ), list_of_evaluatable_strings ), ", ",
                          CellAsEvaluatableString( Target( mor ), list_of_evaluatable_strings ), " )" );
        
    else
        
        string = @Concatenation(
                          "MorphismConstructor( ", cat, ", ",
                          CellAsEvaluatableString( Source( mor ), list_of_evaluatable_strings ), ", ",
                          DatumOfCellAsEvaluatableString( mor, list_of_evaluatable_strings ), ", ",
                          CellAsEvaluatableString( Target( mor ), list_of_evaluatable_strings ), " )" );
        
    end;
    
    #@Assert( 0, IsEqualForMorphismsOnMor( C, mor, EvalString( string ) ) );
    
    return string;
    
end );

##
@InstallGlobalFunction( RELATIVE_WEAK_BI_FIBER_PRODUCT_PREFUNCTION,
  function( cat, morphism_1, morphism_2, morphism_3, arg... )
    local current_value;
    
    current_value = IsEqualForObjects( Target( morphism_1 ), Target( morphism_2 ) );
    
    if (current_value == fail)
        return [ false, "cannot decide whether morphism_1 and morphism_2 have equal ranges" ];
    elseif (current_value == false)
        return [ false, "morphism_1 and morphism_2 must have equal ranges" ];
    end;
    
    current_value = IsEqualForObjects( Target( morphism_3 ), Source( morphism_1 ) );
    
    if (current_value == fail)
        return [ false, "cannot decide whether the range of morphism_3 and the source of morphism_1 are equal" ];
    elseif (current_value == false)
        return [ false, "the range of morphism_3 and the source of morphism_1 must be equal" ];
    end;
    
    return [ true ];
    
  end
);

##
@InstallGlobalFunction( UNIVERSAL_MORPHISM_INTO_BIASED_RELATIVE_WEAK_FIBER_PRODUCT_PREFUNCTION,
  function( cat, morphism_1, morphism_2, morphism_3, test_morphism, arg... )
    local current_value;
    
    current_value = IsEqualForObjects( Target( morphism_1 ), Target( morphism_2 ) );
    
    if (current_value == fail)
        return [ false, "cannot decide whether morphism_1 and morphism_2 have equal ranges" ];
    elseif (current_value == false)
        return [ false, "morphism_1 and morphism_2 must have equal ranges" ];
    end;
    
    current_value = IsEqualForObjects( Target( morphism_3 ), Source( morphism_1 ) );
    
    if (current_value == fail)
        return [ false, "cannot decide whether the range of morphism_3 and the source of morphism_1 are equal" ];
    elseif (current_value == false)
        return [ false, "the range of morphism_3 and the source of morphism_1 must be equal" ];
    end;
    
    current_value = IsEqualForObjects( Source( morphism_1 ), Target( test_morphism ) );
    
    if (current_value == fail)
        return [ false, "cannot decide whether the range of the test morphism is equal to the source of the first morphism " ];
    elseif (current_value == false)
        return [ false, "the range of the test morphism must equal the source of the first morphism" ];
    end;
    
    return [ true ];
    
  end
);

####################################
#
# methods for operations:
#
####################################


##
@InstallMethod( *,
        "for two CAP morphism",
        [ IsCapCategoryMorphism, IsCapCategoryMorphism ],

  function( mor1, mor2 )
    
    return PreCompose( mor1, mor2 );
    
end );

##
@InstallMethod( OneMutableGAP,
        "for a CAP morphism",
        [ IsCapCategoryMorphism ],
        
  function( mor )
    
    if (@not IsEndomorphism( mor ))
        return fail;
    end;
    
    return IdentityMorphism( Source( mor ) );
    
end );

##
@InstallMethod( ^,
        "for a CAP morphism and an integer",
        [ IsCapCategoryMorphism, IsInt ],

  function( mor, power )
    
    if (power == 0)
        return OneMutableGAP( mor );
    end;
    
    if (power < 0)
        mor = Inverse( mor );
        if (mor == fail)
            return mor;
        end;
        power = -power;
    end;
    
    if (power > 1)
        if (@not IsEndomorphism( mor ))
            return fail;
        end;
    end;
    
    return Product( ListWithIdenticalEntries( power, mor ) );
    
end );

##
@InstallMethod( BasisOfSolutionsOfHomogeneousLinearSystemInLinearCategory,
        "for two lists",
        [ IsList, IsList ],
               
  function( left_coeffs, right_coeffs )
    
    return BasisOfSolutionsOfHomogeneousLinearSystemInLinearCategory( CapCategory( right_coeffs[1, 1] ), left_coeffs, right_coeffs );
    
end );

##
@InstallMethod( BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory,
        "for four lists",
        [ IsList, IsList, IsList, IsList ],
        
  function( alpha, beta, gamma, delta )
    
    return BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory(
                    CapCategory( delta[1, 1] ), alpha, beta, gamma, delta
                  );
    
end );

##
@InstallMethod( BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory,
        "for two lists",
        [ IsList, IsList ],

  function( alpha, delta )
    local cat, beta, gamma, i;
    
    cat = CapCategory( alpha[1][1] );
    
    if (@not CanCompute( cat, "BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory" ))
        Error( "the operation <BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory> must be computable in the category named \n:", Name( cat ) );
    end;
    
    beta = List( (1):(Length( alpha )),
                i ->  List( (1):(Length( delta[i] )),
                      function ( j )
                        local alpha_ij, delta_ij;

                        alpha_ij = alpha[i][j];
                        delta_ij = delta[i][j];

                        if (IsEndomorphism( cat, delta_ij ) && @not IsEqualToZeroMorphism( cat, alpha_ij ))
                            return IdentityMorphism( cat, Source( delta_ij ) );
                        else
                            return ZeroMorphism( cat, Source( delta_ij ), Target( delta_ij ) );
                        end;

                      end ) );
    
    gamma = List( (1):(Length( alpha )),
                i ->  List( (1):(Length( alpha[i] )),
                      function ( j )
                        local alpha_ij, delta_ij;

                        alpha_ij = alpha[i][j];
                        delta_ij = delta[i][j];

                        if (IsEndomorphism( cat, alpha_ij ) && @not IsEqualToZeroMorphism( cat, delta_ij ))
                            return IdentityMorphism( cat, Source( alpha_ij ) );
                        else
                            return ZeroMorphism( cat, Source( alpha_ij ), Target( alpha_ij ) );
                        end;

                      end ) );
    
    return BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory( cat, alpha, beta, gamma, delta );
    
end );

##
@InstallMethod( MereExistenceOfUniqueSolutionOfHomogeneousLinearSystemInAbCategory,
        "for two lists",
        [ IsList, IsList ],
        
  function( left_coeffs, right_coeffs )
    
    return MereExistenceOfUniqueSolutionOfLinearSystemInAbCategory( CapCategory( right_coeffs[1,1] ), left_coeffs, right_coeffs );
    
end );

##
CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
        @rec(
            LimitPair =
            [ [ "DirectProduct", 2 ],
              [ "ProjectionInFactorOfDirectProductWithGivenDirectProduct", 2 ], ## called in List
              [ "UniversalMorphismIntoDirectProductWithGivenDirectProduct", 2 ],
              [ "PreCompose", 2 ] ] ## called in List
            )
);

##
@InstallMethod( LimitPair,
        "for a catgory and two lists",
        [ IsCapCategory, IsList, IsList ],
        
  function( cat, objects, decorated_morphisms )
    local source, projections, diagram, tau, range, mor1, compositions, mor2;
    
    source = DirectProduct( cat, objects );
    
    projections = List( (0):(Length( objects ) - 1),
                         i -> ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat, objects, 1 + i, source ) );
    
    diagram = List( decorated_morphisms, m -> objects[1 + m[3]] );
    
    tau = List( decorated_morphisms, m -> projections[1 + m[3]] );
    
    range = DirectProduct( cat, diagram );
    
    mor1 = UniversalMorphismIntoDirectProductWithGivenDirectProduct( cat,
                    diagram, source, tau, range );
    
    compositions = List( decorated_morphisms,
                          m -> PreCompose( cat,
                                  projections[1 + m[1]],
                                  m[2] ) );
    
    mor2 = UniversalMorphismIntoDirectProductWithGivenDirectProduct( cat,
                    diagram, source, compositions, range );
    
    return PairGAP( source, [ mor1, mor2 ] );
    
end );

##
@InstallMethod( LimitPair,
        "for a list",
        [ IsList ],
        
  function( pair )
    
    return LimitPair( CapCategory( pair[1][1] ), pair[1], pair[2] );
    
end );

##
@InstallMethod( Limit,
        "for a catgory and a list",
        [ IsCapCategory, IsList ],
        
  function( C, pair )
    
    return Limit( C, pair[1], pair[2] );
    
end );

##
@InstallMethod( Limit,
        "for a list",
        [ IsList ],
        
  function( pair )
    
    return Limit( CapCategory( pair[1][1] ), pair );
    
end );

##
CAP_INTERNAL_ADD_REPLACEMENTS_FOR_METHOD_RECORD(
        @rec(
            ColimitPair =
            [ [ "Coproduct", 2 ],
              [ "InjectionOfCofactorOfCoproductWithGivenCoproduct", 2 ], ## called in List
              [ "UniversalMorphismFromCoproductWithGivenCoproduct", 2 ],
              [ "PreCompose", 2 ] ] ## called in List
            )
);

##
@InstallMethod( ColimitPair,
        "for a catgory and two lists",
        [ IsCapCategory, IsList, IsList ],
        
  function( cat, objects, decorated_morphisms )
    local range, injections, diagram, tau, source, mor1, compositions, mor2;
    
    range = Coproduct( cat, objects );
    
    injections = List( (0):(Length( objects ) - 1),
                         i -> InjectionOfCofactorOfCoproductWithGivenCoproduct( cat, objects, 1 + i, range ) );
    
    diagram = List( decorated_morphisms, m -> objects[1 + m[1]] );
    
    tau = List( decorated_morphisms, m -> injections[1 + m[1]] );
    
    source = Coproduct( cat, diagram );
    
    mor1 = UniversalMorphismFromCoproductWithGivenCoproduct( cat,
                    diagram, range, tau, source );
    
    compositions = List( decorated_morphisms,
                          m -> PreCompose( cat,
                                  m[2],
                                  injections[1 + m[3]] ) );
    
    mor2 = UniversalMorphismFromCoproductWithGivenCoproduct( cat,
                    diagram, range, compositions, source );
    
    return PairGAP( range, [ mor1, mor2 ] );
    
end );

##
@InstallMethod( ColimitPair,
        "for a list",
        [ IsList ],
        
  function( pair )
    
    return ColimitPair( CapCategory( pair[1][1] ), pair[1], pair[2] );
    
end );

##
@InstallMethod( Colimit,
        "for a catgory and a list",
        [ IsCapCategory, IsList ],
        
  function( C, pair )
    
    return Colimit( C, pair[1], pair[2] );
    
end );

##
@InstallMethod( Colimit,
        "for a list",
        [ IsList ],
        
  function( pair )
    
    return Colimit( CapCategory( pair[1][1] ), pair );
    
end );

##
@InstallMethod( PreComposeFunctorsByData,
        [ IsCapCategory, IsList, IsList ],
        
  function( C, pre_functor_data, post_functor_data )
    local A, B, composed_functor_on_objects, composed_functor_on_morphisms;
    
    A = pre_functor_data[1];
    B = pre_functor_data[3];
    
    #% CAP_JIT_DROP_NEXT_STATEMENT
    @Assert( 0, IsIdenticalObj( B, post_functor_data[1] ) );
    
    #% CAP_JIT_DROP_NEXT_STATEMENT
    @Assert( 0, IsIdenticalObj( C, post_functor_data[3] ) );
    
    composed_functor_on_objects =
      function( objA )
        
        return post_functor_data[2][1]( pre_functor_data[2][1]( objA ) );
        
    end;
    
    composed_functor_on_morphisms =
      function( sourceC, morA, rangeC )
        local sourceB, rangeB;
        
        sourceB = pre_functor_data[2][1]( Source( morA ) );
        rangeB = pre_functor_data[2][1]( Target( morA ) );
        
        return post_functor_data[2][2](
                       sourceC,
                       pre_functor_data[2][2](
                               sourceB,
                               morA,
                               rangeB ),
                       rangeC );
        
    end;
    
    return Triple( A,
                   PairGAP( composed_functor_on_objects, composed_functor_on_morphisms ),
                   C );
    
end );

##
@InstallMethod( PreComposeWithWrappingFunctorData,
        [ IsWrapperCapCategory, IsList ],
        
  function( C, functor_data )
    local A, B, wrapping_functor_on_objects, wrapping_functor_on_morphisms, wrapping_functor_data;
    
    A = functor_data[1];
    B = functor_data[3];
    
    #% CAP_JIT_DROP_NEXT_STATEMENT
    @Assert( 0, IsIdenticalObj( B, ModelingCategory( C ) ) );
    
    wrapping_functor_on_objects = objB -> AsObjectInWrapperCategory( C, objB );
    
    wrapping_functor_on_morphisms = ( sourceC, morB, rangeC ) -> AsMorphismInWrapperCategory( C, sourceC, morB, rangeC );
    
    wrapping_functor_data =
      Triple( B,
              PairGAP( wrapping_functor_on_objects, wrapping_functor_on_morphisms ),
              C );
    
    return PreComposeFunctorsByData( C,
              functor_data,
              wrapping_functor_data );
    
end );

##
@InstallMethod( ExtendFunctorToWrapperCategoryData,
        "for a two categories and a pair of functions",
        [ IsWrapperCapCategory, IsList, IsCapCategory ],
        
  function( W, pair_of_funcs, range_category )
    local functor_on_objects, functor_on_morphisms,
          extended_functor_on_objects, extended_functor_on_morphisms;
    
    functor_on_objects = pair_of_funcs[1];
    functor_on_morphisms = pair_of_funcs[2];
    
    extended_functor_on_objects =
      function( objW )
        
        return functor_on_objects( ObjectDatum( W, objW ) );
        
    end;
    
    extended_functor_on_morphisms =
      function( source, morW, range )
        
        return functor_on_morphisms(
                       source,
                       MorphismDatum( W, morW ),
                       range );
        
    end;
    
    return Triple( W,
                   PairGAP( extended_functor_on_objects, extended_functor_on_morphisms ),
                   range_category );
    
end );

##
@InstallGlobalFunction( CAP_INTERNAL_CORRESPONDING_WITH_GIVEN_OBJECTS_METHOD,
  function( name_of_cap_operation, list_of_installed_operations )
    local info, with_given_operation_name, info_of_with_given, with_given_object_name, pair, list;
    
    info = CAP_INTERNAL_METHOD_NAME_RECORD[name_of_cap_operation];
    
    @Assert( 0, @IsBound( info.with_given_without_given_name_pair ) );
    
    if (!( @IsBound( info.with_given_without_given_name_pair ) &&
             IsList( info.with_given_without_given_name_pair ) &&
             Length( info.with_given_without_given_name_pair ) == 2 &&
             name_of_cap_operation == info.with_given_without_given_name_pair[1] &&
             #@IsBound( info.with_given_without_given_name_pair[2] ) and
             @IsBound( CAP_INTERNAL_METHOD_NAME_RECORD[info.with_given_without_given_name_pair[2]].with_given_object_name ) ))
        
        return [ name_of_cap_operation ];
        
    end;
    
    @Assert( 0, info.return_type in [ "morphism", "morphism_in_range_category_of_homomorphism_structure" ] );
    
    ## do not install this operation for morphisms but its
    ## with-given-object counterpart and the object
    
    with_given_operation_name = info.with_given_without_given_name_pair[2];
    
    info_of_with_given = CAP_INTERNAL_METHOD_NAME_RECORD[with_given_operation_name];
    
    @Assert( 0, @IsBound( info_of_with_given.is_with_given ) );
    @Assert( 0, info_of_with_given.is_with_given == true );
    @Assert( 0, @IsBound( info_of_with_given.with_given_object_name ) );
    
    with_given_object_name = info_of_with_given.with_given_object_name;
    
    @Assert( 0, @IsBound( info.output_source_getter_preconditions ) );
    @Assert( 0, @IsBound( info.output_range_getter_preconditions ) );
    
    if (@not with_given_object_name in list_of_installed_operations)
        Error( "unable to find \"", with_given_object_name, "\" in `list_of_installed_operations`\n" );
    elseif (@not with_given_operation_name in list_of_installed_operations)
        Error( "unable to find \"", with_given_operation_name, "\" in `list_of_installed_operations`\n" );
    end;
    
    pair = [ with_given_object_name, with_given_operation_name ];
    
    list = SortedList( @Concatenation(
                    List( info.output_source_getter_preconditions, e -> e[1] ),
                    List( info.output_range_getter_preconditions, e -> e[1] ),
                    [ with_given_operation_name ] ) );
    
    @Assert( 0, IsSubset( list, pair ) );
    
    return list;
    
end );

##
@InstallMethod( ListPrimitivelyInstalledOperationsOfCategoryWhereMorphismOperationsAreReplacedWithCorrespondingObjectAndWithGivenOperations,
        "for two lists",
        [ IsList, IsList ],
        
  function( list_of_primitively_installed_operations, list_of_installed_operations )
    local list_of_replaced_primitively_installed_operations, name;
    
    list_of_replaced_primitively_installed_operations = [ ];
    
    for name in list_of_primitively_installed_operations
        
        Append( list_of_replaced_primitively_installed_operations, CAP_INTERNAL_CORRESPONDING_WITH_GIVEN_OBJECTS_METHOD( name, list_of_installed_operations ) );
        
    end;
    
    return SortedList( list_of_replaced_primitively_installed_operations );
    
end );

##
@InstallMethod( ListPrimitivelyInstalledOperationsOfCategoryWhereMorphismOperationsAreReplacedWithCorrespondingObjectAndWithGivenOperations,
        "for a CAP category",
        [ IsCapCategory ],
        
  function( C )
    
    if (@not IsFinalized( C ))
        Error( "the input category `C` is not finalized\n" );
    end;
    
    return ListPrimitivelyInstalledOperationsOfCategoryWhereMorphismOperationsAreReplacedWithCorrespondingObjectAndWithGivenOperations(
                   ListPrimitivelyInstalledOperationsOfCategory( C ),
                   ListInstalledOperationsOfCategory( C ) );
    
end );

##
@InstallGlobalFunction( PositionsOfSublist,
  
  function ( arg... )
    local suplist, sublist, pos, len, positions;
    
    suplist = arg[1];
    sublist = arg[2];
    
    if (Length( arg ) == 3)
        pos = arg[3];
    else
        pos = 0;
    end;
    
    len = Length( suplist );
    positions = [];
    
    while true
      
      pos = PositionSublist( suplist, sublist, pos );
      
      if (pos != fail && pos <= len)
            Add( positions, pos );
      end;
      
      if ((pos == fail) || (pos >= len))
        break;
      end;
      
    end;
    
    return positions;
    
end );

#= comment for Julia
##
@InstallMethod( \.,
        "for an opposite category and a positive integer",
        [ IsCapCategory && WasCreatedAsOppositeCategory, IsPosInt ],
        
  function( C_op, string_as_int )
    local name, C, c;
    
    name = NameRNam( string_as_int );
    
    C = OppositeCategory( C_op );
    
    c = C[name];
    
    if (IsCapCategoryObject( c ) && IsIdenticalObj( CapCategory( c ), C ))
        
        return ObjectConstructor( C_op, c );
        
    elseif (IsCapCategoryMorphism( c ) && IsIdenticalObj( CapCategory( c ), C ))
        
        return MorphismConstructor( C_op,
                       ObjectConstructor( C_op, Target( c ) ),
                       c,
                       ObjectConstructor( C_op, Source( c ) ) );
        
    else
        
        Error( "`c` is neither an object nor a morphism in the category `C = OppositeCategory( C_op )`\n" );
        
    end;
    
end );

##
@InstallMethod( AllCoproducts,
        "for a CAP category and a list of objects",
        [ IsCapCategory && IsCocartesianCategory, IsList ],
        
  function( cat, objects )
    local l, predicate, func, coproducts_initial_value;
    
    l = Length( objects );
    
    predicate =
      function( coproducts, coproducts_new )
        
        return Length( Last( coproducts_new ) ) == 0 ||
               Length( coproducts ) == l + 1;
        
    end;
    
    func =
      function( coproducts )
        local i, largest_coproducts, new_coproducts, coproducts_new, r, pair, coproduct, m, pos;
        
        i = Length( coproducts );
        
        largest_coproducts = Last( coproducts );
        
        new_coproducts = [ ];
        
        coproducts_new = @Concatenation( coproducts, [ new_coproducts ] );
        
        for r in (i):(l)
            for pair in largest_coproducts
                if (r > Maximum( pair[1] ))
                    
                    coproduct = BinaryCoproduct( cat, pair[2], objects[r] );
                    
                    for m in (2):(i + 1)
                        pos = PositionProperty( coproducts_new[m], entry -> IsEqualForObjects( cat, entry[2], coproduct ) );
                        
                        if (IsInt( pos ))
                            Add( coproducts_new[m][pos][1], r );
                            break;
                        end;
                        
                    end;
                    
                    if (pos == fail)
                        Add( new_coproducts, PairGAP( @Concatenation( pair[1], [ r ] ), coproduct ) );
                    end;
                    
                end;
            end;
        end;
        
        return coproducts_new;
        
    end;
    
    coproducts_initial_value = [ [ PairGAP( [ ], InitialObject( cat ) ) ],
                                  List( (1):(l), i -> PairGAP( [ i ], objects[i] ) ) ];
    
    return CapFixpoint( predicate, func, coproducts_initial_value );
    
end );

##
@InstallValueConst( RECORD_OF_COMPACT_NAMES_OF_CATEGORICAL_OPERATIONS,
        @rec(
            HomomorphismStructureOnObjects = "HomStructure\nOnObjects",
            HomomorphismStructureOnMorphismsWithGivenObjects = "HomStructure\nOnMorphisms\nWithGivenObjects",
            InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism = "InterpretMorphism\nFromDistinguishedObject\nToHomStructure\nAsMorphism",
            InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure = "InterpretMorphism\nAsMorphismFrom\nDistinguishedObject\nToHomStructure"
            ) );

##
@InstallGlobalFunction( CAP_INTERNAL_COMPACT_NAME_OF_CATEGORICAL_OPERATION,
  function( name )
    local l, posUniv, posCaps, posWith, posFrom, posInto, posOfCommutativeRing, i, posOf, posHom, cname;
    
    if (@IsBound( RECORD_OF_COMPACT_NAMES_OF_CATEGORICAL_OPERATIONS[name] ))
        return RECORD_OF_COMPACT_NAMES_OF_CATEGORICAL_OPERATIONS[name];
    end;
    
    l = Length( name );
    
    posUniv = PositionSublist( name, "UniversalMorphism" );
    posCaps = PositionProperty( name, i -> i in "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 2 );
    posWith = PositionSublist( name, "WithGiven" );
    posFrom = PositionSublist( name, "From" );
    posInto = PositionSublist( name, "Into" );
    posOfCommutativeRing = PositionSublist( name, "OfCommutativeRing" );
    
    # find last occurrence of "Of"
    posOf = fail;
    for i in (Length( name ) - 2):(0)
        posOf = PositionSublist( name, "Of", i );
        if (posOf != fail)
            break;
        end;
    end;
    posHom = PositionSublist( name, "HomomorphismStructure" );
    
    cname = name;
    
    if (IsInt( posWith ))
        if (posWith > l / 2)
            if (IsInt( posOf ))
                cname = @Concatenation(
                                 name[(1):(posOf - 1)], "\n", name[(posOf):(posWith - 1)], "\n",
                                 name[(posWith):(l)] );
            else
                if (IsInt( posUniv ))
                    cname = @Concatenation( name[(1):(17)], "\n", name[(18):(posWith - 1)], "\n", name[(posWith):(posWith + 8)], "\n", name[(posWith + 9):(l)] );
                else
                    if (IsInt( posHom ))
                        cname = @Concatenation( name[(1):(21)], "\n", name[(22):(posWith - 1)], "\n", name[(posWith):(l)] );
                    else
                        cname = @Concatenation( name[(1):(posWith - 1)], "\n", name[(posWith):(l)] );
                    end;
                end;
            end;
        else
            if (IsInt( posOf ))
                if (IsInt( posUniv ))
                    cname = @Concatenation(
                                     name[(1):(17)], "\n", name[(18):(posOf - 1)], "\n", name[(posOf):(posWith - 1)], "\n",
                                     name[(posWith):(posWith + 8)], "\n", name[(posWith + 9):(l)] );
                else
                    cname = @Concatenation(
                                     name[(1):(posOf - 1)], "\n", name[(posOf):(posWith - 1)], "\n",
                                     name[(posWith):(posWith + 8)], "\n", name[(posWith + 9):(l)] );
                end;
            else
                if (IsInt( posUniv ))
                    cname = @Concatenation( name[(1):(17)], "\n", name[(18):(posWith - 1)], "\n", name[(posWith):(posWith + 8)], "\n", name[(posWith + 9):(l)] );
                else
                    cname = @Concatenation( name[(1):(posWith - 1)], "\n", name[(posWith):(posWith + 8)], "\n", name[(posWith + 9):(l)] );
                end;
            end;
        end;
    elseif (IsInt( posFrom ))
        cname = @Concatenation( name[(1):(posFrom - 1)], "\n", name[(posFrom):(l)] );
    elseif (IsInt( posInto ))
        cname = @Concatenation( name[(1):(posInto - 1)], "\n", name[(posInto):(l)] );
    elseif (IsInt( posOfCommutativeRing ))
        cname = @Concatenation( name[(1):(posOfCommutativeRing - 1)], "\n", name[(posOfCommutativeRing):(posOfCommutativeRing + 16)], "\n", name[(posOfCommutativeRing + 17):(l)] );
    elseif (IsInt( posCaps ) && posCaps / l >= 1/3 && posCaps / l <= 2/3)
        cname = @Concatenation(
                         name[(1):(posCaps - 1)], "\n", name[(posCaps):(l)] );
    end;
    
    RECORD_OF_COMPACT_NAMES_OF_CATEGORICAL_OPERATIONS[name] = cname;
    
    return cname;
    
end );
# =#
