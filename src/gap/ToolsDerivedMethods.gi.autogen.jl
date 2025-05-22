# SPDX-License-Identifier: GPL-2.0-or-later
# ToolsForCategoricalTowers: Tools for CategoricalTowers
#
# Implementations
#

####################################
#
# categorical methods derivations:
#
####################################

##
AddDerivationToCAP( SetOfObjectsOfCategory,
        "SetOfObjectsOfCategory for the initial category",
        [  ],
        
  function( initial_category )
    
    return [ ];
    
end; CategoryFilter = cat -> HasIsInitialCategory( cat ) && IsInitialCategory( cat ) );

##
AddDerivationToCAP( SetOfMorphismsOfFiniteCategory,
        "SetOfMorphismsOfFiniteCategory for the initial category",
        [  ],
        
  function( initial_category )
    
    return [ ];
    
end; CategoryFilter = cat -> HasIsInitialCategory( cat ) && IsInitialCategory( cat ) );

##
AddDerivationToCAP( SetOfMorphismsOfFiniteCategory,
        "SetOfMorphismsOfFiniteCategory using SetOfObjectsOfCategory and MorphismsOfExternalHom",
        [ [ SetOfObjectsOfCategory, 1 ],
          [ MorphismsOfExternalHom, 4 ] ],
        
  function( C )
    local objs;
    
    objs = SetOfObjectsOfCategory( C );
    
    ## varying the target (column-index) before varying the source ("row"-index)
    ## in the for-loops below is enforced by SetOfMorphismsOfFiniteCategory for IsCategoryFromNerveData,
    ## which in turn is enforced by our convention for ProjectionInFactorOfDirectProduct in SkeletalFinSets,
    ## which is the "double-reverse" convention of the GAP command Cartesian:
    
    # gap> A = FinSet( 3 );
    # |3|
    # gap> B = FinSet( 4 );
    # |4|
    # gap> data = List( [ A, B ], AsList );
    # [ (0):(2), (0):(3) ]
    # gap> pi1 = ProjectionInFactorOfDirectProduct( [ A, B ], 1 );
    # |12| → |3|
    # gap> pi2 = ProjectionInFactorOfDirectProduct( [ A, B ], 2 );
    # |12| → |4|
    # gap> List( (0):(11), i -> [ pi1(i), pi2(i) ] );
    # [ [ 0, 0 ], [ 1, 0 ], [ 2, 0 ], [ 0, 1 ], [ 1, 1 ], [ 2, 1 ], [ 0, 2 ], [ 1, 2 ], [ 2, 2 ], [ 0, 3 ], [ 1, 3 ], [ 2, 3 ] ]
    # gap> List( Cartesian( Reversed( data ) ), Reversed );
    # [ [ 0, 0 ], [ 1, 0 ], [ 2, 0 ], [ 0, 1 ], [ 1, 1 ], [ 2, 1 ], [ 0, 2 ], [ 1, 2 ], [ 2, 2 ], [ 0, 3 ], [ 1, 3 ], [ 2, 3 ] ]
    # gap> L1 == L2;
    # true
    # gap> Cartesian( data );
    # [ [ 0, 0 ], [ 0, 1 ], [ 0, 2 ], [ 0, 3 ], [ 1, 0 ], [ 1, 1 ], [ 1, 2 ], [ 1, 3 ], [ 2, 0 ], [ 2, 1 ], [ 2, 2 ], [ 2, 3 ] ]
    # gap> L1 == L3;
    # false
    
    return @Concatenation( List( objs, t ->
                   @Concatenation( List( objs, s ->
                           MorphismsOfExternalHom( C, s, t ) ) ) ) );
    
end; CategoryFilter = cat -> HasIsFiniteCategory( cat ) && IsFiniteCategory( cat ) );

##
AddDerivationToCAP( MorphismBetweenCoproductsWithGivenCoproducts,
        "MorphismBetweenCoproductsWithGivenCoproducts using universal morphisms of coproducts  (with support for empty coproducts)",
        [ [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
          [ PreCompose, 2 ],
          [ UniversalMorphismFromCoproductWithGivenCoproduct, 1 ] ],
        
  function( cat, source, diagram_source, F, diagram_range, range )
    local s, map, mor, inj, cmp;
    
    ## the code below is the morphism-part of the doctrine-specific ur-algorithm for strict cocartesian (monoidal) categories
    
    s = Length( diagram_source );
    
    map = F[1];
    mor = F[2];
    
    inj = List( (0):(s - 1), i ->
                 InjectionOfCofactorOfCoproductWithGivenCoproduct( cat,
                         diagram_range,
                         1 + map[1 + i],
                         range ) );
    
    cmp = List( (0):(s - 1), i ->
                 PreCompose( cat,
                         mor[1 + i],
                         inj[1 + i] ) );
    
    return UniversalMorphismFromCoproductWithGivenCoproduct( cat,
                   diagram_source,
                   range,
                   cmp,
                   source );
    
end; CategoryFilter = cat -> @IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true );

##
AddDerivationToCAP( MorphismBetweenCoproductsWithGivenCoproducts,
        "MorphismBetweenCoproductsWithGivenCoproducts using universal morphisms of coproducts (without support for empty coproducts)",
        [ [ UniversalMorphismFromInitialObjectWithGivenInitialObject, 1 ],
          [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
          [ PreCompose, 2 ],
          [ UniversalMorphismFromCoproductWithGivenCoproduct, 1 ] ],
        
  function( cat, source, diagram_source, F, diagram_range, range )
    local s, map, mor, inj, cmp;
    
    ## the code below is the morphism-part of the doctrine-specific ur-algorithm for strict cocartesian (monoidal) categories
    
    s = Length( diagram_source );
    
    ## the empty case
    if (s == 0)
        
        return UniversalMorphismFromInitialObjectWithGivenInitialObject( cat, range, source );
        
    end;
    
    map = F[1];
    mor = F[2];
    
    inj = List( (0):(s - 1), i ->
                 InjectionOfCofactorOfCoproductWithGivenCoproduct( cat,
                         diagram_range,
                         1 + map[1 + i],
                         range ) );
    
    cmp = List( (0):(s - 1), i ->
                 PreCompose( cat,
                         mor[1 + i],
                         inj[1 + i] ) );
    
    return UniversalMorphismFromCoproductWithGivenCoproduct( cat,
                   diagram_source,
                   range,
                   cmp,
                   source );
    
end; CategoryFilter = cat -> !( @IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true ) );

##
AddDerivationToCAP( MorphismBetweenDirectProductsWithGivenDirectProducts,
        "MorphismBetweenDirectProductsWithGivenDirectProducts using universal morphisms of direct products  (with support for empty direct products)",
        [ [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
          [ PreCompose, 2 ],
          [ UniversalMorphismIntoDirectProductWithGivenDirectProduct, 1 ] ],
        
  function( cat, source, diagram_source, F, diagram_range, range )
    local t, map, mor, prj, cmp;
    
    ## the code below is the morphism-part of the doctrine-specific ur-algorithm for strict cartesian (monoidal) categories
    
    t = Length( diagram_range );
    
    map = F[1];
    mor = F[2];
    
    prj = List( (0):(t - 1), j ->
                 ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat,
                         diagram_source,
                         1 + map[1 + j],
                         source ) );
    
    cmp = List( (0):(t - 1), j ->
                 PreCompose( cat,
                         prj[1 + j],
                         mor[1 + j] ) );
    
    return UniversalMorphismIntoDirectProductWithGivenDirectProduct( cat,
                   diagram_range,
                   source,
                   cmp,
                   range );
    
end; CategoryFilter = cat -> @IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true );

##
AddDerivationToCAP( MorphismBetweenDirectProductsWithGivenDirectProducts,
        "MorphismBetweenDirectProductsWithGivenDirectProducts using universal morphisms of direct products (without support for empty direct products)",
        [ [ UniversalMorphismIntoTerminalObjectWithGivenTerminalObject, 1 ],
          [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
          [ PreCompose, 2 ],
          [ UniversalMorphismIntoDirectProductWithGivenDirectProduct, 1 ] ],
        
  function( cat, source, diagram_source, F, diagram_range, range )
    local t, map, mor, prj, cmp;
    
    ## the code below is the morphism-part of the doctrine-specific ur-algorithm for strict cartesian (monoidal) categories
    
    t = Length( diagram_range );
    
    ## the empty case
    if (t == 0)
        
        return UniversalMorphismIntoTerminalObjectWithGivenTerminalObject( cat, source, range );
        
    end;
    
    map = F[1];
    mor = F[2];
    
    prj = List( (0):(t - 1), j ->
                 ProjectionInFactorOfDirectProductWithGivenDirectProduct( cat,
                         diagram_source,
                         1 + map[1 + j],
                         source ) );
    
    cmp = List( (0):(t - 1), j ->
                 PreCompose( cat,
                         prj[1 + j],
                         mor[1 + j] ) );
    
    return UniversalMorphismIntoDirectProductWithGivenDirectProduct( cat,
                   diagram_range,
                   source,
                   cmp,
                   range );
    
end; CategoryFilter = cat -> !( @IsBound( cat.supports_empty_limits ) && cat.supports_empty_limits == true ) );

##
AddDerivationToCAP( BiasedRelativeWeakFiberProduct,
                    "BiasedRelativeWeakFiberProduct as the source of ProjectionOfBiasedRelativeWeakFiberProduct",
                    [ [ ProjectionOfBiasedRelativeWeakFiberProduct, 1 ] ],
                    
  function( cat, alpha, beta, gamma )
    
    return Source( ProjectionOfBiasedRelativeWeakFiberProduct( alpha, beta, gamma ) );
    
end );

##
AddDerivationToCAP( UniversalMorphismIntoBiasedRelativeWeakFiberProduct,
                    "UniversalMorphismIntoBiasedRelativeWeakFiberProduct using RelativeLift",
                    [ [ RelativeLift, 1 ],
                      [ ProjectionOfBiasedRelativeWeakFiberProduct, 1 ] ],
                    
  function( cat, alpha, beta, gamma, test_mor )
    
    return RelativeLift( test_mor,
                 ProjectionOfBiasedRelativeWeakFiberProduct( alpha, beta, gamma ), gamma );
    
end );

##
AddDerivationToCAP( MorphismOntoSumOfImagesOfAllMorphisms,
                    "MorphismOntoSumOfImagesOfAllMorphisms using BasisOfExternalHom and UniversalMorphismFromDirectSum",
                    [ [ BasisOfExternalHom, 1 ],
                      [ UniversalMorphismFromZeroObject, 1 ],
                      [ UniversalMorphismFromDirectSum, 1 ] ],
                    
  function( cat, a, b )
    local hom;
    
    hom = BasisOfExternalHom( cat, a, b );
    
    if (hom == [ ])
        return UniversalMorphismFromZeroObject( cat, b );
    end;
    
    return UniversalMorphismFromDirectSum( cat, hom );
    
end; CategoryFilter = IsAbelianCategory );

##
AddDerivationToCAP( EmbeddingOfSumOfImagesOfAllMorphisms,
                    "EmbeddingOfSumOfImagesOfAllMorphisms using MorphismOntoSumOfImagesOfAllMorphisms and ImageEmbedding",
                    [ [ MorphismOntoSumOfImagesOfAllMorphisms, 1 ],
                      [ ImageEmbedding, 1 ] ],
                    
  function( cat, a, b )
    
    return ImageEmbedding( cat, MorphismOntoSumOfImagesOfAllMorphisms( cat, a, b ) );
    
end; CategoryFilter = IsAbelianCategory );

##
AddDerivationToCAP( SumOfImagesOfAllMorphisms,
                    "SumOfImagesOfAllMorphisms as Source of EmbeddingOfSumOfImagesOfAllMorphisms",
                    [ [ EmbeddingOfSumOfImagesOfAllMorphisms, 1 ] ],
                    
  function( cat, a, b )
    
    return Source( EmbeddingOfSumOfImagesOfAllMorphisms( cat, a, b ) );
    
end; CategoryFilter = IsAbelianCategory );

##
AddDerivationToCAP( BasisOfSolutionsOfHomogeneousLinearSystemInLinearCategory,
                    "BasisOfSolutionsOfHomogeneousLinearSystemInLinearCategory using the homomorphism structure",
                    [ [ HomomorphismStructureOnMorphisms, 4 ],
                      [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ HomomorphismStructureOnObjects, 4 ],
                      [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 4 ],
                      [ MorphismBetweenDirectSums, 1, RangeCategoryOfHomomorphismStructure ],
                      [ PreCompose, 6, RangeCategoryOfHomomorphismStructure ],
                      [ KernelEmbedding, 1, RangeCategoryOfHomomorphismStructure ],
                      [ BasisOfExternalHom, 1, RangeCategoryOfHomomorphismStructure ],
                      [ ProjectionInFactorOfDirectSum, 4, RangeCategoryOfHomomorphismStructure ] ],
                    
  function ( cat, left_coefficients, right_coefficients )
    local range_cat, m, n, distinguished_object, H_B_C, H_A_D, list, iota, basis;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    m = Length( left_coefficients );
    
    n = Length( left_coefficients[1] );
    
    distinguished_object = DistinguishedObjectOfHomomorphismStructure( cat );
    
    H_B_C = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Target( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    H_A_D = List( (1):(m), i -> HomomorphismStructureOnObjects( cat, Source( left_coefficients[i][1] ), Target( right_coefficients[i][1] ) ) );
    
    list =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphisms( cat, left_coefficients[i][j], right_coefficients[i][j] ) )
    );
    
    iota = KernelEmbedding( range_cat, MorphismBetweenDirectSums( range_cat, H_B_C, list, H_A_D ) );
    
    basis = BasisOfExternalHom( range_cat, distinguished_object, Source( iota ) );
    
    basis = List( basis, m -> PreCompose( range_cat, m, iota ) );
    
    basis =
      List( basis, m ->
        List( (1):(n), j ->
          InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat,
            Target( left_coefficients[1][j] ),
            Source( right_coefficients[1][j] ),
            PreCompose( range_cat, m, ProjectionInFactorOfDirectSum( range_cat, H_B_C, j ) ) ) ) );
    
    return basis;
    
  end,
  CategoryGetters = @rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter = cat -> HasIsLinearCategoryOverCommutativeRing( cat ) && IsLinearCategoryOverCommutativeRing( cat ) && HasRangeCategoryOfHomomorphismStructure( cat )
);

##
AddDerivationToCAP( BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory,
                    "BasisOfSolutionsOfHomogeneousDoubleLinearSystemInLinearCategory using the homomorphism structure",
                    [ [ HomomorphismStructureOnObjects, 4 ],
                      [ HomomorphismStructureOnMorphisms, 8 ],
                      [ InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism, 4 ],
                      [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ MorphismBetweenDirectSums, 2, RangeCategoryOfHomomorphismStructure ],
                      [ PreCompose, 6, RangeCategoryOfHomomorphismStructure ],
                      [ SubtractionForMorphisms, 1, RangeCategoryOfHomomorphismStructure ],
                      [ KernelEmbedding, 1, RangeCategoryOfHomomorphismStructure ],
                      [ BasisOfExternalHom, 1, RangeCategoryOfHomomorphismStructure ],
                      [ ProjectionInFactorOfDirectSum, 4, RangeCategoryOfHomomorphismStructure ] ],
                    
  function ( cat, alpha, beta, gamma, delta )
    local range_cat, m, n, distinguished_object, H_B_C, H_A_D, list_1, H_1, list_2, H_2, iota, basis;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    m = Length( alpha );
    
    n = Length( alpha[1] );
    
    distinguished_object = DistinguishedObjectOfHomomorphismStructure( cat );
    
    H_B_C = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Target( alpha[1][j] ), Source( beta[1][j] ) ) );
    
    H_A_D = List( (1):(m), i -> HomomorphismStructureOnObjects( cat, Source( alpha[i][1] ), Target( beta[i][1] ) ) );
    
    list_1 =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphisms( cat, alpha[i][j], beta[i][j] ) )
    );
    
    H_1 = MorphismBetweenDirectSums( range_cat, H_B_C, list_1, H_A_D );

    list_2 =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphisms( cat, gamma[i][j], delta[i][j] ) )
    );
    
    H_2 = MorphismBetweenDirectSums( range_cat, H_B_C, list_2, H_A_D );
    
    iota = KernelEmbedding( range_cat, SubtractionForMorphisms( range_cat, H_1, H_2 ) );
    
    basis = BasisOfExternalHom( range_cat, distinguished_object, Source( iota ) );
    
    basis = List( basis, m -> PreCompose( range_cat, m, iota ) );
    
    basis =
      List( basis, m ->
        List( (1):(n), j ->
          InterpretMorphismFromDistinguishedObjectToHomomorphismStructureAsMorphism( cat,
            Target( alpha[1][j] ),
            Source( beta[1][j] ),
            PreCompose( range_cat, m, ProjectionInFactorOfDirectSum( range_cat, H_B_C, j ) ) ) ) );
    
    return basis;
    
  end,
  CategoryGetters = @rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter = cat -> HasIsLinearCategoryOverCommutativeRing( cat ) && IsLinearCategoryOverCommutativeRing( cat ) && HasRangeCategoryOfHomomorphismStructure( cat )
);

##
AddDerivationToCAP( MereExistenceOfUniqueSolutionOfLinearSystemInAbCategory,
                    "MereExistenceOfUniqueSolutionOfLinearSystemInAbCategory using the homomorphism structure",
                    [ [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure, 2 ],
                      [ HomomorphismStructureOnObjects, 4 ],
                      [ HomomorphismStructureOnMorphismsWithGivenObjects, 4 ],
                      [ UniversalMorphismIntoDirectSum, 1, RangeCategoryOfHomomorphismStructure ],
                      [ MorphismBetweenDirectSums, 1, RangeCategoryOfHomomorphismStructure ],
                      [ IsLiftable, 1, RangeCategoryOfHomomorphismStructure ],
                      [ IsMonomorphism, 1, RangeCategoryOfHomomorphismStructure ] ],
                    
  function ( cat, left_coefficients, right_coefficients, right_side )
    local range_cat, m, n, distinguished_object, interpretations, nu, H_B_C, H_A_D, list, H;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    m = Length( left_coefficients );
    
    n = Length( left_coefficients[1] );
    
    ## create lift diagram
    
    distinguished_object = DistinguishedObjectOfHomomorphismStructure( cat );
    interpretations = List( (1):(m), i -> InterpretMorphismAsMorphismFromDistinguishedObjectToHomomorphismStructure( cat, right_side[i] ) );
    
    nu = UniversalMorphismIntoDirectSum( range_cat,
        List( interpretations, mor -> Target( mor ) ),
        distinguished_object,
        interpretations
    );
    
    # left_coefficients[i][j]; A_i -> B_j
    # right_coefficients[i][j]; C_j -> D_i
    
    H_B_C = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Target( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    H_A_D = List( (1):(m), i -> HomomorphismStructureOnObjects( cat, Source( left_coefficients[i][1] ), Target( right_coefficients[i][1] ) ) );
    
    list =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphismsWithGivenObjects( cat, H_B_C[j], left_coefficients[i][j], right_coefficients[i][j], H_A_D[i] ) )
    );
    
    H = MorphismBetweenDirectSums( range_cat, H_B_C, list, H_A_D );
    
    ## the actual computation of the solution
    return IsMonomorphism( range_cat, H ) && IsLiftable( range_cat, nu, H );
    
  end,
  CategoryGetters = @rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter = cat -> HasIsAbCategory( cat ) && IsAbCategory( cat ) && HasRangeCategoryOfHomomorphismStructure( cat )
                            && HasIsAbelianCategory( RangeCategoryOfHomomorphismStructure( cat ) ) && IsAbelianCategory( RangeCategoryOfHomomorphismStructure( cat ) )
);

##
AddDerivationToCAP( MereExistenceOfUniqueSolutionOfHomogeneousLinearSystemInAbCategory,
                    "MereExistenceOfUniqueSolutionOfHomogeneousLinearSystemInAbCategory using the homomorphism structure",
                    [ [ DistinguishedObjectOfHomomorphismStructure, 1 ],
                      [ HomomorphismStructureOnObjects, 4 ],
                      [ HomomorphismStructureOnMorphisms, 4 ],
                      [ MorphismBetweenDirectSums, 1, RangeCategoryOfHomomorphismStructure ],
                      [ IsMonomorphism, 1, RangeCategoryOfHomomorphismStructure ] ],
                    
  function ( cat, left_coefficients, right_coefficients )
    local range_cat, m, n, distinguished_object, H_B_C, H_A_D, list, H;
    
    range_cat = RangeCategoryOfHomomorphismStructure( cat );
    
    m = Length( left_coefficients );
    
    n = Length( left_coefficients[1] );
    
    distinguished_object = DistinguishedObjectOfHomomorphismStructure( cat );
    
    H_B_C = List( (1):(n), j -> HomomorphismStructureOnObjects( cat, Target( left_coefficients[1][j] ), Source( right_coefficients[1][j] ) ) );
    
    H_A_D = List( (1):(m), i -> HomomorphismStructureOnObjects( cat, Source( left_coefficients[i][1] ), Target( right_coefficients[i][1] ) ) );
    
    list =
      List( (1):(n),
      j -> List( (1):(m), i -> HomomorphismStructureOnMorphisms( cat, left_coefficients[i][j], right_coefficients[i][j] ) )
    );
    
    H = MorphismBetweenDirectSums( range_cat, H_B_C, list, H_A_D );
    
    return IsMonomorphism( range_cat, H );
    
  end,
  CategoryGetters = @rec( range_cat = RangeCategoryOfHomomorphismStructure ),
  CategoryFilter = cat -> HasIsAbCategory( cat ) && IsAbCategory( cat ) && HasRangeCategoryOfHomomorphismStructure( cat ) &&
                            HasIsAbelianCategory( RangeCategoryOfHomomorphismStructure( cat ) ) && IsAbelianCategory( RangeCategoryOfHomomorphismStructure( cat ) )
);

##
AddFinalDerivationBundle( "Limit using DirectProduct and Equalizer",
        [ [ DirectProduct, 2 ],
          [ Equalizer, 1 ],
          [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ], ## called in List
          [ UniversalMorphismIntoDirectProductWithGivenDirectProduct, 2 ],
          [ PreCompose, 3 ], ## called in List
          [ EmbeddingOfEqualizerWithGivenEqualizer, 1 ],
          [ ProjectionInFactorOfDirectProduct, 1 ],
          [ UniversalMorphismIntoDirectProduct, 1 ],
          [ LiftAlongMonomorphism, 1 ],
          ],
        [ Limit,
          ProjectionInFactorOfLimit,
          ProjectionInFactorOfLimitWithGivenLimit,
          UniversalMorphismIntoLimit,
          UniversalMorphismIntoLimitWithGivenLimit,
          ],
[
  Limit,
  [ [ Equalizer, 1 ],
    [ DirectProduct, 2 ],
    [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
    [ UniversalMorphismIntoDirectProductWithGivenDirectProduct, 2 ],
    [ PreCompose, 2 ] ],
  function( cat, objects, decorated_morphisms )
    local pair;
    
    pair = LimitPair( cat,
                    objects,
                    decorated_morphisms );
    
    return Equalizer( cat, pair[1], pair[2] );
    
  end
],
[
  ProjectionInFactorOfLimitWithGivenLimit,
  [ [ PreCompose, 3 ],
    [ EmbeddingOfEqualizerWithGivenEqualizer, 1 ],
    [ ProjectionInFactorOfDirectProduct, 1 ],
    [ DirectProduct, 2 ],
    [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
    [ UniversalMorphismIntoDirectProductWithGivenDirectProduct, 2 ] ],
  function( cat, objects, decorated_morphisms, k, limit )
    local pair;
    
    pair = LimitPair( cat,
                    objects,
                    decorated_morphisms );
    
    return PreCompose( cat,
                   EmbeddingOfEqualizerWithGivenEqualizer( cat,
                           pair[1],
                           pair[2],
                           limit ),
                   ProjectionInFactorOfDirectProduct( cat,
                           objects,
                           1 + k ) );
    
  end
],
[
  UniversalMorphismIntoLimitWithGivenLimit,
  [ [ LiftAlongMonomorphism, 1 ],
    [ EmbeddingOfEqualizerWithGivenEqualizer, 1 ],
    [ UniversalMorphismIntoDirectProduct, 1 ],
    [ DirectProduct, 2 ],
    [ ProjectionInFactorOfDirectProductWithGivenDirectProduct, 2 ],
    [ UniversalMorphismIntoDirectProductWithGivenDirectProduct, 2 ],
    [ PreCompose, 2 ] ],
  function( cat, objects, decorated_morphisms, T, tau, limit )
    local pair;
    
    pair = LimitPair( cat,
                    objects,
                    decorated_morphisms );
    
    return LiftAlongMonomorphism( cat,
                   EmbeddingOfEqualizerWithGivenEqualizer( cat,
                           pair[1],
                           pair[2],
                           limit ),
                   UniversalMorphismIntoDirectProduct( cat,
                           objects,
                           T,
                           tau ) );
    
  end
]
 );

##
AddFinalDerivationBundle( "Colimit using limit in the opposite category",
        ## FIXME: remove the following list and add it to CategoryFilter;
        ## problem: Input category must be finalized to create opposite category
        [ [ Coproduct, 2 ],
          [ Coequalizer, 1 ],
          [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ], ## called in List
          [ UniversalMorphismFromCoproductWithGivenCoproduct, 2 ],
          [ PreCompose, 3 ], ## called in List
          [ ProjectionOntoCoequalizerWithGivenCoequalizer, 1 ],
          [ InjectionOfCofactorOfCoproduct, 1 ],
          [ UniversalMorphismFromCoproduct, 1 ],
          [ ColiftAlongEpimorphism, 1 ],
          ],
        [ Colimit,
          InjectionOfCofactorOfColimit,
          InjectionOfCofactorOfColimitWithGivenColimit,
          UniversalMorphismFromColimit,
          UniversalMorphismFromColimitWithGivenColimit,
          ],
[
  Colimit,
  [ [ Coequalizer, 1 ],
    [ Coproduct, 2 ],
    [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
    [ UniversalMorphismFromCoproductWithGivenCoproduct, 2 ],
    [ PreCompose, 2 ] ],
  function( cat, objects, decorated_morphisms )
    local pair;
    
    pair = ColimitPair( cat,
                    objects,
                    decorated_morphisms );
    
    return Coequalizer( cat, pair[1], pair[2] );
    
  end
],
[
  InjectionOfCofactorOfColimitWithGivenColimit,
  [ [ PreCompose, 3 ],
    [ ProjectionOntoCoequalizerWithGivenCoequalizer, 1 ],
    [ InjectionOfCofactorOfCoproduct, 1 ],
    [ Coproduct, 2 ],
    [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
    [ UniversalMorphismFromCoproductWithGivenCoproduct, 2 ] ],
  function( cat, objects, decorated_morphisms, k, colimit )
    local pair;
    
    pair = ColimitPair( cat,
                    objects,
                    decorated_morphisms );
    
    return PreCompose( cat,
                   InjectionOfCofactorOfCoproduct( cat,
                           objects,
                           1 + k ),
                   ProjectionOntoCoequalizerWithGivenCoequalizer( cat,
                           pair[1],
                           pair[2],
                           colimit ) );
    
  end
],
[
  UniversalMorphismFromColimitWithGivenColimit,
  [ [ ColiftAlongEpimorphism, 1 ],
    [ ProjectionOntoCoequalizerWithGivenCoequalizer, 1 ],
    [ UniversalMorphismFromCoproduct, 1 ],
    [ Coproduct, 2 ],
    [ InjectionOfCofactorOfCoproductWithGivenCoproduct, 2 ],
    [ UniversalMorphismFromCoproductWithGivenCoproduct, 2 ],
    [ PreCompose, 2 ] ],
  function( cat, objects, decorated_morphisms, T, tau, colimit )
    local pair;
    
    pair = ColimitPair( cat,
                    objects,
                    decorated_morphisms );
    
    return ColiftAlongEpimorphism( cat,
                   ProjectionOntoCoequalizerWithGivenCoequalizer( cat,
                           pair[1],
                           pair[2],
                           colimit ),
                   UniversalMorphismFromCoproduct( cat,
                           objects,
                           T,
                           tau ) );
    
  end
]
 );

##
AddFinalDerivationBundle( "SomeProjectiveObject from ProjectiveCoverObject",
        [ [ ProjectiveCoverObject, 1 ],
          [ EpimorphismFromProjectiveCoverObjectWithGivenProjectiveCoverObject, 1 ],
          ],
        [ SomeProjectiveObject,
          EpimorphismFromSomeProjectiveObject,
          EpimorphismFromSomeProjectiveObjectWithGivenSomeProjectiveObject,
          ],
[
  SomeProjectiveObject,
  [ [ ProjectiveCoverObject, 1 ] ],
  function( cat, F )
    
    return ProjectiveCoverObject( cat, F );
    
end
],
[
  EpimorphismFromSomeProjectiveObjectWithGivenSomeProjectiveObject,
  [ [ EpimorphismFromProjectiveCoverObjectWithGivenProjectiveCoverObject, 1 ] ],
  function( cat, F, P )
    
    return EpimorphismFromProjectiveCoverObjectWithGivenProjectiveCoverObject( cat, F, P );
    
end
]
 );

##
AddFinalDerivationBundle( "SomeInjectiveObject from InjectiveEnvelopeObject",
        [ [ InjectiveEnvelopeObject, 1 ],
          [ MonomorphismIntoInjectiveEnvelopeObjectWithGivenInjectiveEnvelopeObject, 1 ],
          ],
        [ SomeInjectiveObject,
          MonomorphismIntoSomeInjectiveObject,
          MonomorphismIntoSomeInjectiveObjectWithGivenSomeInjectiveObject,
          ],
[
  SomeInjectiveObject,
  [ [ InjectiveEnvelopeObject, 1 ] ],
  function( cat, F )
    
    return InjectiveEnvelopeObject( cat, F );
    
end
],
[
  MonomorphismIntoSomeInjectiveObjectWithGivenSomeInjectiveObject,
  [ [ MonomorphismIntoInjectiveEnvelopeObjectWithGivenInjectiveEnvelopeObject, 1 ] ],
  function( cat, F, P )
    
    return MonomorphismIntoInjectiveEnvelopeObjectWithGivenInjectiveEnvelopeObject( cat, F, P );
    
end
]
 );
