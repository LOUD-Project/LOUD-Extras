
local OLDAddGlobalBaseTemplate = AddGlobalBaseTemplate
function AddGlobalBaseTemplate(aiBrain, locationType, baseBuilderName)
    SPEW('Nuclear Repulsor Shields: Injecting BuilderGroup "NuclearRepulsorShields"')
    AddGlobalBuilderGroup(aiBrain, locationType, 'NuclearRepulsorShields')
    OLDAddGlobalBaseTemplate(aiBrain, locationType, baseBuilderName)
end
