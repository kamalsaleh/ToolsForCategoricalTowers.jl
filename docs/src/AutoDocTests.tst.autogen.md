
```jldoctest AutoDocTests
julia> using CAP; using MonoidalCategories; using CartesianCategories; using Toposes; using FinSetsForCAP; using MatricesForHomalg; using FreydCategoriesForCAP; using ToolsForCategoricalTowers

julia> true
true

julia> D1 = DummyCategoryInDoctrines( [ "IsAbCategory" ] )
DummyCategoryInDoctrines( [ "IsAbCategory" ] )

julia> Display( D1 )
A CAP category with name DummyCategoryInDoctrines( [ "IsAbCategory" ] ):

16 primitive operations were used to derive 28 operations for this category which algorithmically
* IsAbCategory

julia> D2 = DummyCategoryInDoctrines( [ "IsAbCategory", "IsAbelianCategory" ] )
DummyCategoryInDoctrines( [ "IsAbelianCategory" ] )

julia> Display( D2 )
A CAP category with name DummyCategoryInDoctrines( [ "IsAbelianCategory" ] ):

33 primitive operations were used to derive 291 operations for this category which algorithmically
* IsAbelianCategory

julia> D3 = DummyCategoryInDoctrines(
                      [ "IsCategoryWithInitialObject",
                        "IsCategoryWithTerminalObject",
                        "IsCategoryWithZeroObject" ] )
DummyCategoryInDoctrines( [ "IsCategoryWithInitialObject", "IsCategoryWithTerminalObject", "IsCategoryWithZeroObject" ] )

julia> Display( D3 )
A CAP category with name DummyCategoryInDoctrines( [ "IsCategoryWithInitialObject", "IsCategoryWithTerminalObject", "IsCategoryWithZeroObject" ] ):

18 primitive operations were used to derive 41 operations for this category which algorithmically
* IsCategoryWithZeroObject

julia> D4 = DummyCategoryInDoctrines(
                      [ "IsCategoryWithInitialObject",
                        "IsCategoryWithTerminalObject",
                        "IsCategoryWithZeroObject" ]; minimal = true )
DummyCategoryInDoctrines( [ "IsCategoryWithZeroObject" ] )

julia> Display( D4 )
A CAP category with name DummyCategoryInDoctrines( [ "IsCategoryWithZeroObject" ] ):

14 primitive operations were used to derive 41 operations for this category which algorithmically
* IsCategoryWithZeroObject

```

```jldoctest AutoDocTests
julia> using CAP; using MonoidalCategories; using CartesianCategories; using Toposes; using FinSetsForCAP; using MatricesForHomalg; using FreydCategoriesForCAP; using ToolsForCategoricalTowers

julia> true
true

julia> sFinSets = SkeletalCategoryOfFiniteSets( )
SkeletalFinSets

julia> Display( sFinSets )
A CAP category with name SkeletalFinSets:

58 primitive operations were used to derive 348 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsElementaryTopos
and furthermore mathematically
* IsSkeletalCategory
* IsStrictCartesianCategory
* IsStrictCocartesianCategory

julia> a = FinSet( sFinSets, BigInt( 2 ) )
|2|

julia> b = FinSet( sFinSets, BigInt( 3 ) )
|3|

julia> beta = CocartesianBraiding( a, b )
|5| → |5|

julia> Display( beta )
[ 0,..., 4 ] ⱶ[ 3, 4, 0, 1, 2 ]→ [ 0,..., 4 ]

julia> id_a = IdentityMorphism( a )
|2| → |2|

julia> id_b = IdentityMorphism( b )
|3| → |3|

julia> f = PairGAP( [ 1, 0 ], [ id_a, id_b ] );

julia> beta2 = MorphismBetweenCoproducts( [ a, b ], f, [ b, a ] )
|5| → |5|

julia> beta2 == beta
true

julia> W = WrapperCategory( sFinSets,
                     @rec( only_primitive_operations = false ) )
WrapperCategory( SkeletalFinSets )

julia> Display( W )
A CAP category with name WrapperCategory( SkeletalFinSets ):

324 primitive operations were used to derive 338 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsElementaryTopos
and furthermore mathematically
* IsSkeletalCategory
* IsStrictCartesianCategory
* IsStrictCocartesianCategory

julia> W_a = a / W
<An object in WrapperCategory( SkeletalFinSets )>

julia> W_b = b / W
<An object in WrapperCategory( SkeletalFinSets )>

julia> W_beta = CocartesianBraiding( W_a, W_b )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> MorphismDatum( W_beta ) == beta
true

julia> W_id_a = IdentityMorphism( W_a )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> W_id_b = IdentityMorphism( W_b )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> W_f = PairGAP( [ 1, 0 ], [ W_id_a, W_id_b ] );

julia> W_beta2 = MorphismBetweenCoproducts( [ W_a, W_b ], W_f, [ W_b, W_a ] )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> W_beta2 == W_beta
true

julia> O = Opposite( sFinSets )
Opposite( SkeletalFinSets )

julia> Display( O )
A CAP category with name Opposite( SkeletalFinSets ):

257 primitive operations were used to derive 273 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsBicartesianCoclosedCategory
* IsFiniteBicompleteCategory
and furthermore mathematically
* IsSkeletalCategory
* IsStrictCartesianCategory
* IsStrictCocartesianCategory

julia> O_a = a / O
<An object in Opposite( SkeletalFinSets )>

julia> O_b = b / O
<An object in Opposite( SkeletalFinSets )>

julia> O_beta = CartesianBraiding( O_b, O_a )
<A morphism in Opposite( SkeletalFinSets )>

julia> MorphismDatum( O_beta ) == beta
true

julia> O_id_a = IdentityMorphism( O_a )
<A morphism in Opposite( SkeletalFinSets )>

julia> O_id_b = IdentityMorphism( O_b )
<A morphism in Opposite( SkeletalFinSets )>

julia> O_f = PairGAP( [ 1, 0 ], [ O_id_a, O_id_b ] );

julia> O_beta2 = MorphismBetweenDirectProducts( [ O_b, O_a ], O_f, [ O_a, O_b ] )
<A morphism in Opposite( SkeletalFinSets )>

julia> O_beta2 == O_beta
true

```

```jldoctest AutoDocTests
julia> using CAP; using MonoidalCategories; using CartesianCategories; using Toposes; using FinSetsForCAP; using MatricesForHomalg; using FreydCategoriesForCAP; using ToolsForCategoricalTowers

julia> true
true

julia> true
true

julia> true
true

julia> sFinSets = SkeletalCategoryOfFiniteSets( )
SkeletalFinSets

julia> Display( sFinSets )
A CAP category with name SkeletalFinSets:

58 primitive operations were used to derive 348 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsElementaryTopos
and furthermore mathematically
* IsSkeletalCategory
* IsStrictCartesianCategory
* IsStrictCocartesianCategory

julia> a = FinSet( sFinSets, BigInt( 2 ) )
|2|

julia> b = FinSet( sFinSets, BigInt( 3 ) )
|3|

julia> beta = CartesianBraiding( a, b )
|6| → |6|

julia> Display( beta )
[ 0,..., 5 ] ⱶ[ 0, 3, 1, 4, 2, 5 ]→ [ 0,..., 5 ]

julia> id_a = IdentityMorphism( a )
|2| → |2|

julia> id_b = IdentityMorphism( b )
|3| → |3|

julia> f = PairGAP( [ 1, 0 ], [ id_b, id_a ] );

julia> beta2 = MorphismBetweenDirectProducts( [ a, b ], f, [ b, a ] )
|6| → |6|

julia> beta2 == beta
true

julia> W = WrapperCategory( sFinSets,
                     @rec( only_primitive_operations = false ) )
WrapperCategory( SkeletalFinSets )

julia> Display( W )
A CAP category with name WrapperCategory( SkeletalFinSets ):

324 primitive operations were used to derive 338 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsElementaryTopos
and furthermore mathematically
* IsSkeletalCategory
* IsStrictCartesianCategory
* IsStrictCocartesianCategory

julia> W_a = a / W
<An object in WrapperCategory( SkeletalFinSets )>

julia> W_b = b / W
<An object in WrapperCategory( SkeletalFinSets )>

julia> W_beta = CartesianBraiding( W_a, W_b )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> MorphismDatum( W_beta ) == beta
true

julia> W_id_a = IdentityMorphism( W_a )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> W_id_b = IdentityMorphism( W_b )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> W_f = PairGAP( [ 1, 0 ], [ W_id_b, W_id_a ] );

julia> W_beta2 = MorphismBetweenDirectProducts( [ W_a, W_b ], W_f, [ W_b, W_a ] )
<A morphism in WrapperCategory( SkeletalFinSets )>

julia> W_beta2 == W_beta
true

julia> O = Opposite( sFinSets )
Opposite( SkeletalFinSets )

julia> Display( O )
A CAP category with name Opposite( SkeletalFinSets ):

257 primitive operations were used to derive 273 operations for this category which algorithmically
* IsCategoryWithDecidableColifts
* IsCategoryWithDecidableLifts
* IsEquippedWithHomomorphismStructure
* IsBicartesianCoclosedCategory
* IsFiniteBicompleteCategory
and furthermore mathematically
* IsSkeletalCategory
* IsStrictCartesianCategory
* IsStrictCocartesianCategory

julia> O_a = a / O
<An object in Opposite( SkeletalFinSets )>

julia> O_b = b / O
<An object in Opposite( SkeletalFinSets )>

julia> O_beta = CocartesianBraiding( O_b, O_a )
<A morphism in Opposite( SkeletalFinSets )>

julia> MorphismDatum( O_beta ) == beta
true

julia> O_id_a = IdentityMorphism( O_a )
<A morphism in Opposite( SkeletalFinSets )>

julia> O_id_b = IdentityMorphism( O_b )
<A morphism in Opposite( SkeletalFinSets )>

julia> O_f = PairGAP( [ 1, 0 ], [ O_id_b, O_id_a ] );

julia> O_beta2 = MorphismBetweenCoproducts( [ O_b, O_a ], O_f, [ O_a, O_b ] )
<A morphism in Opposite( SkeletalFinSets )>

julia> O_beta2 == O_beta
true

```

```jldoctest AutoDocTests
julia> using CAP; using MonoidalCategories; using CartesianCategories; using Toposes; using FinSetsForCAP; using MatricesForHomalg; using FreydCategoriesForCAP; using ToolsForCategoricalTowers

julia> true
true

julia> true
true

julia> QQ = HomalgFieldOfRationals();

julia> QQ_rows = CategoryOfRows( QQ )
Rows( Q )

julia> t = TensorUnit( QQ_rows )
<A row module over Q of rank 1>

julia> id_t = IdentityMorphism( t )
<A morphism in Rows( Q )>

julia> 1*(11)*7 + 2*(12)*8 + 3*(13)*9
620

julia> 4*(11)*3 + 5*(12)*4 + 6*(13)*1
450

julia> alpha_s =  [ [ 1/QQ * id_t, 2/QQ * id_t, 3/QQ * id_t ], [ 4/QQ * id_t, 5/QQ * id_t, 6/QQ * id_t ] ];

julia> beta_s = [ [ 7/QQ * id_t, 8/QQ * id_t, 9/QQ * id_t ], [ 3/QQ * id_t, 4/QQ * id_t, 1/QQ * id_t ] ];

julia> gamma_s = [ 620/QQ * id_t, 450/QQ * id_t ];

julia> MereExistenceOfSolutionOfLinearSystemInAbCategory(
                                          QQ_rows, alpha_s, beta_s, gamma_s )
true

julia> MereExistenceOfUniqueSolutionOfLinearSystemInAbCategory(
                                          QQ_rows, alpha_s, beta_s, gamma_s )
false

julia> x = SolveLinearSystemInAbCategory( QQ_rows, alpha_s, beta_s, gamma_s );

julia> (1*7)/QQ * x[1] + (2*8)/QQ * x[2] + (3*9)/QQ * x[3] == gamma_s[1]
true

julia> (4*3)/QQ * x[1] + (5*4)/QQ * x[2] + (6*1)/QQ * x[3] == gamma_s[2]
true

julia> MereExistenceOfUniqueSolutionOfHomogeneousLinearSystemInAbCategory(
                                          QQ_rows, alpha_s, beta_s )
false

julia> B = BasisOfSolutionsOfHomogeneousLinearSystemInLinearCategory(
                                          QQ_rows, alpha_s, beta_s );

julia> Length( B )
1

julia> (1*7)/QQ * B[1][1] + (2*8)/QQ * B[1][2] + (3*9)/QQ * B[1][3] == 0/QQ * id_t
true

julia> (4*3)/QQ * B[1][1] + (5*4)/QQ * B[1][2] + (6*1)/QQ * B[1][3] == 0/QQ * id_t
true

julia> 2*(11)*5 + 3*(12)*7 + 9*(13)*2
596

julia> Add( alpha_s, [ 2/QQ * id_t, 3/QQ * id_t, 9/QQ * id_t ] );

julia> Add( beta_s, [ 5/QQ * id_t, 7/QQ * id_t, 2/QQ * id_t ] );

julia> Add( gamma_s, 596/QQ * id_t );

julia> MereExistenceOfSolutionOfLinearSystemInAbCategory(
                                          QQ_rows, alpha_s, beta_s, gamma_s )
true

julia> MereExistenceOfUniqueSolutionOfLinearSystemInAbCategory(
                                          QQ_rows, alpha_s, beta_s, gamma_s )
true

julia> x = SolveLinearSystemInAbCategory( QQ_rows, alpha_s, beta_s, gamma_s );

julia> (1*7)/QQ * x[1] + (2*8)/QQ * x[2] + (3*9)/QQ * x[3] == gamma_s[1]
true

julia> (4*3)/QQ * x[1] + (5*4)/QQ * x[2] + (6*1)/QQ * x[3] == gamma_s[2]
true

julia> (2*5)/QQ * x[1] + (3*7)/QQ * x[2] + (9*2)/QQ * x[3] == gamma_s[3]
true

julia> MereExistenceOfUniqueSolutionOfHomogeneousLinearSystemInAbCategory(
                                          QQ_rows, alpha_s, beta_s )
true

julia> B = BasisOfSolutionsOfHomogeneousLinearSystemInLinearCategory(
                                          QQ_rows, alpha_s, beta_s );

julia> Length( B )
0

```
