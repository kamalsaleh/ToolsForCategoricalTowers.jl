

```jldoctest
julia> using CAP; using MonoidalCategories; using CartesianCategories; using Toposes; using FinSetsForCAP; using MatricesForHomalg; using FreydCategoriesForCAP; using ToolsForCategoricalTowers


julia> true
true

julia> true
true

julia> T = TerminalCategoryWithMultipleObjects( );

julia> opposite = Opposite( T, "Opposite with all operations" );

julia> opposite_primitive = Opposite( T, "Opposite with primitive operations"; only_primitive_operations = true );


julia> a = "a" / T;

julia> b = "b" / T;

julia> c = "c" / T;

julia> d = "d" / T;


julia> alpha = MorphismConstructor( a, "f_ab", b );

julia> beta = MorphismConstructor( c, "f_cd", d );


julia> CartesianCategoriesTest( T, opposite, a, b, c, alpha, beta );

julia> CartesianCategoriesTest( T, opposite_primitive, a, b, c, alpha, beta );


julia> z = ZeroObject( T );


julia> alpha = UniversalMorphismFromZeroObject( a );

julia> beta = UniversalMorphismIntoZeroObject( a );


julia> CartesianCategoriesTest( T, opposite, z, a, a, alpha, beta );

julia> CartesianCategoriesTest( T, opposite_primitive, z, a, a, alpha, beta );


julia> CartesianCategoriesTest( T, opposite, a, z, z, beta, alpha );

julia> CartesianCategoriesTest( T, opposite_primitive, a, z, z, beta, alpha );


julia> a = "a" / T;

julia> b = "b" / T;

julia> c = "c" / T;

julia> d = "d" / T;


julia> alpha = MorphismConstructor( a, "f_ab", b );

julia> beta = MorphismConstructor( c, "f_cd", d );


julia> CocartesianCategoriesTest( T, opposite, a, b, c, alpha, beta );

julia> CocartesianCategoriesTest( T, opposite_primitive, a, b, c, alpha, beta );


julia> z = ZeroObject( T );


julia> alpha = UniversalMorphismFromZeroObject( a );

julia> beta = UniversalMorphismIntoZeroObject( a );


julia> CocartesianCategoriesTest( T, opposite, z, a, a, alpha, beta );

julia> CocartesianCategoriesTest( T, opposite_primitive, z, a, a, alpha, beta );


julia> CocartesianCategoriesTest( T, opposite, a, z, z, beta, alpha );

julia> CocartesianCategoriesTest( T, opposite_primitive, a, z, z, beta, alpha );


julia> a = "a" / T;

julia> L = [ "b" / T, "c" / T, "d" / T ];


julia> DistributiveCartesianCategoriesTest( T, opposite, a, L );

julia> DistributiveCartesianCategoriesTest( T, opposite_primitive, a, L );


julia> a = "a" / T;

julia> L = [ "b" / T, "c" / T, "d" / T ];


julia> CodistributiveCocartesianCategoriesTest( T, opposite, a, L );

julia> CodistributiveCocartesianCategoriesTest( T, opposite_primitive, a, L );


julia> a = "a" / T;

julia> b = "b" / T;


julia> BraidedCartesianCategoriesTest( T, opposite, a, b );

julia> BraidedCartesianCategoriesTest( T, opposite_primitive, a, b );


julia> BraidedCartesianCategoriesTest( T, opposite, b, a );

julia> BraidedCartesianCategoriesTest( T, opposite_primitive, b, a );


julia> z = ZeroObject( T );


julia> BraidedCartesianCategoriesTest( T, opposite, z, a );

julia> BraidedCartesianCategoriesTest( T, opposite_primitive, z, a );


julia> BraidedCartesianCategoriesTest( T, opposite, a, z );

julia> BraidedCartesianCategoriesTest( T, opposite_primitive, a, z );


julia> a = "a" / T;

julia> b = "b" / T;


julia> BraidedCocartesianCategoriesTest( T, opposite, a, b );

julia> BraidedCocartesianCategoriesTest( T, opposite_primitive, a, b );


julia> BraidedCocartesianCategoriesTest( T, opposite, b, a );

julia> BraidedCocartesianCategoriesTest( T, opposite_primitive, b, a );


julia> z = ZeroObject( T );


julia> BraidedCocartesianCategoriesTest( T, opposite, z, a );

julia> BraidedCocartesianCategoriesTest( T, opposite_primitive, z, a );


julia> BraidedCocartesianCategoriesTest( T, opposite, a, z );

julia> BraidedCocartesianCategoriesTest( T, opposite_primitive, a, z );


julia> a = "a" / T;

julia> b = "b" / T;

julia> c = "c" / T;

julia> d = "d" / T;


julia> t = TerminalObject( T );


julia> a_product_b = DirectProduct( a, b );

julia> c_product_d = DirectProduct( c, d );


julia> exp_ab = Exponential( a, b );

julia> exp_cd = Exponential( c, d );


julia> alpha = MorphismConstructor( a, "f_ab", b );

julia> beta = MorphismConstructor( c, "f_cd", d );

julia> gamma = MorphismConstructor( a_product_b, "f_abt", t );

julia> delta = MorphismConstructor( c_product_d, "f_cdt", t );

julia> epsilon = MorphismConstructor( t, "f_texpab", exp_ab );

julia> zeta = MorphismConstructor( t, "f_texpcd", exp_cd );


julia> CartesianClosedCategoriesTest( T, opposite, a, b, c, d, alpha, beta, gamma, delta, epsilon, zeta );

julia> CartesianClosedCategoriesTest( T, opposite_primitive, a, b, c, d, alpha, beta, gamma, delta, epsilon, zeta );


julia> z = ZeroObject( T );


julia> z_product_a = DirectProduct( z, a );

julia> a_product_z = DirectProduct( a, z );


julia> exp_za = Exponential( z, a );

julia> exp_az = Exponential( a, z );


julia> alpha = MorphismConstructor( z, "f_za", a );

julia> beta = MorphismConstructor( a, "f_az", z );

julia> gamma = MorphismConstructor( z_product_a, "f_zat", t );

julia> delta = MorphismConstructor( a_product_z, "f_azt", t );

julia> epsilon = MorphismConstructor( t, "f_texpza", exp_za );

julia> zeta = MorphismConstructor( t, "f_texpaz", exp_az );


julia> CartesianClosedCategoriesTest( T, opposite, z, a, a, z, alpha, beta, gamma, delta, epsilon, zeta );

julia> CartesianClosedCategoriesTest( T, opposite_primitive, z, a, a, z, alpha, beta, gamma, delta, epsilon, zeta );


julia> a = "a" / T;

julia> b = "b" / T;

julia> c = "c" / T;

julia> d = "d" / T;


julia> i = InitialObject( T );


julia> a_product_b = Coproduct( a, b );

julia> c_product_d = Coproduct( c, d );


julia> coexp_ab = Coexponential( a, b );

julia> coexp_cd = Coexponential( c, d );


julia> alpha = MorphismConstructor( a, "f_ab", b );

julia> beta = MorphismConstructor( c, "f_cd", d );

julia> gamma = MorphismConstructor( i, "f_iab", a_product_b );

julia> delta = MorphismConstructor( i, "f_icd", c_product_d );

julia> epsilon = MorphismConstructor( coexp_ab, "f_coexpabi", i );

julia> zeta = MorphismConstructor( coexp_cd, "f_coexpcdi", i );


julia> CocartesianCoclosedCategoriesTest( T, opposite, a, b, c, d, alpha, beta, gamma, delta, epsilon, zeta );

julia> CocartesianCoclosedCategoriesTest( T, opposite_primitive, a, b, c, d, alpha, beta, gamma, delta, epsilon, zeta );


julia> z = ZeroObject( T );


julia> z_product_a = Coproduct( z, a );

julia> a_product_z = Coproduct( a, z );


julia> coexp_za = Coexponential( z, a );

julia> coexp_az = Coexponential( a, z );


julia> alpha = MorphismConstructor( z, "f_za", a );

julia> beta = MorphismConstructor( a, "f_az", z );

julia> gamma = MorphismConstructor( i, "f_iza", z_product_a );

julia> delta = MorphismConstructor( i, "f_iaz", a_product_z );

julia> epsilon = MorphismConstructor( coexp_za, "f_coexpzai", i );

julia> zeta = MorphismConstructor( coexp_az, "coexpazi", i );


julia> CocartesianCoclosedCategoriesTest( T, opposite, z, a, a, z, alpha, beta, gamma, delta, epsilon, zeta );

julia> CocartesianCoclosedCategoriesTest( T, opposite_primitive, z, a, a, z, alpha, beta, gamma, delta, epsilon, zeta );


```
