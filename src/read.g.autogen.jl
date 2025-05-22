# SPDX-License-Identifier: GPL-2.0-or-later
# ToolsForCategoricalTowers: Tools for CategoricalTowers
#
# Reading the implementation part of the package.
#

include( "gap/Tools.gi.autogen.jl" );
include( "gap/ToolsMethodRecord.gi.autogen.jl" );
include( "gap/ToolsMethodRecordInstallations.autogen.gi.autogen.jl" );
include( "gap/ToolsDerivedMethods.gi.autogen.jl" );

#= comment for Julia
if IsPackageMarkedForLoading( "Digraphs", ">= 1.3.1" ) then
    include( "gap/ToolsUsingDigraphs.gi.autogen.jl" );
fi;

if IsPackageMarkedForLoading( "JuliaInterface", ">= 0.2" ) then
    include( "gap/Julia.gi.autogen.jl" );
fi;
# =#
