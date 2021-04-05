--[[------------------------------------------------------------------------
--  File     :  /lua/EW_DefaultUnits.lua
--  Author(s):  Manimal
--  Summary  :  Default definitions of the following units :
--   1°) PORTAL FACTORY - Scripted by MANIMAL
--   2°) HERO UNIT - Scripted by MANIMAL
--   3°) STRUCTURE UNIT - Modified by MANIMAL
--   4°) VETERAN FACTORY - Scripted by MANIMAL
--   5°) FACTORY & DERIVED CLASSES - Modified by MANIMAL
--   6°) SUB FACTORY - Scripted by ??? - Some corrections by MANIMAL
--   7°) LABORATORY & DERIVED CLASSES - Scripted by MANIMAL
--   8°) INSTANT RALLYPOINT PORTAL FACTORY  - Scripted by MANIMAL
--  ----------------------------------------------------------
--  Revis.by :  Manimal
--  Rev.Date :  dd mmmmm 2009 -> HÉROS ET SON PORTAIL version 1
--  Rev.Date :  14 décembre 2009 -> LABO version 1
--  Rev.Date :  26 janvier 2011 07:24 -> LABO version 5.2
--  Rev.Date :  10 février 2011 11:27 -> PORTAIL RALLIEMENT INSTANTANÉ version 1
--  Rev.Date :  15 février 2011 22:20 -> Optimisation de quelques fonctions
--  Rev.Date :  07 mars 2011 01:22 -> Correction de quelques fonctions
--  Rev.Date :  21 mars 2011 07:22 -> LES DÉGATS DES TÉLÉPORTEURS SONT MAINTENANT ALÉATOIRES
--  Rev.Date :  17 avril 2011 13:50 -> LES BOUCLIERS SONT MAINTENANT ANTI-TÉLÉPORTATION
--  Rev.Date :  11 juillet 2011 -> MODIF. ANTI-TÉLÉPORTATION PAR DÉCALAGE COORDONNÉES HORS BOUCLIERS
--  Rev.Date :  12 juillet 2011 -> LES COMMANDEURS SONT MAINTENANT ANTI-TÉLÉPORTATION
--  Rev.Date :  13 juillet 2011 -> DEBUG
--  Rev.Date :  31 juillet 2011 -> Ajustements de dernière minute imposés par Asdrubael
--  Rev.Date :  01 aout 2011 -> Ajustements de dernière minute imposés par Asdrubael
--  Rev.Date :  08 aout 2011 -> DÉPLACEMENT DES MODULES ANTI-TÉLÉPORTATION DANS Unit.lua
--  ----------------------------------------------------------
--  Revis.by :  nnnnnnn
--  Rev.Date :  dd mmmmm yyyy
--  ----------------------------------------------------------
--  Copyright © 2009 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--

--[[
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- À FAIRE :
-- ~~~~~~~~~
-- ¤ RETROUVER LA RECHERCHE EXACTE ( 'VETERAN', ETC )
-- ¤ REVOIR LAYER DE SUB RESEARCH LAB UNIT :
--   -- local targetLayer = unite:GetCurrentLayer()
--   -- if not (cdrLayer == 'Land' and (targetLayer == 'Air' or targetLayer == 'Sub' or targetLayer == 'Seabed'))
--   -- and not (cdrLayer == 'Seabed' and (targetLayer == 'Air' or targetLayer == 'Water')) then
--   -- CheckEnabledType('Submarine')
-- ¤ UTILISER bp.Display.ShowBuildEffectsDuringUpgrade ? ---- COPIÉ DE units.lua
-- ¤ SUBMERSIBLES = CATÉGORIE DISTINCTE À AJOUTER DANS formations.lua ?
--
-- ¤ OnCreate DEVRAIT SUFFIR À CONTRER LA TRICHE VIA [ALT][F2]
--   SI TRICHE DESTRUCTION :
--   -> PORTAILS en trop.
--   -> HÉROS en trop.
--   -> LABOS en trop.
-- ¤ VÉRIFIER SetMaintenanceConsumptionActive ET SetActiveConsumptionActive
--   -- SetMaintenanceConsumptionActive = function( self )
--   -- SetActiveConsumptionActive = function( self )
-- ¤
-- ¤ AMÉLIORER GESTION DES ÉCHECS ET ERREURS.
-- ¤ UTILISER categories.SORTOTHER DANS LE BP UBC ?
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]--

--[[
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- NOTES WIP :
-- ~~~~~~~~~~~
-- ¤
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]--


--===============================================================================
local Game = import('/lua/game.lua')

-- VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
--===============================================================================



--------------------------------------------------------------------------------
--
--  DÉFINITION UTILES AUX UNITÉS DU MOD Experimental Wars version 2
--
--------------------------------------------------------------------------------


local EffectTemplate = import( '/lua/EffectTemplates.lua' )


--===============================================================================
-- IMPORT DES MODULES MODIFIÉS POUR LES BESOINS DE Experimental Wars version 2
--===============================================================================

--[[
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- NOTE DE MANIMAL :
-- HOOK ICI DES MODULES IMPORTÉS, FAUTE DE MIEUX (Hook de /lua/defaultunits.lua)
-- AFIN DE FORCER StructureUnit ET FactoryUnit À PRENDRE EN COMPTE MES MODIFS
-- DE LA CLASSE Unit LIÉES À OnKilled ET OnDestroy (voir /lua/sim/Unit.lua)
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]--

local Unit = import( '/lua/sim/Unit.lua' ).Unit
local DefaultUnits = import( '/lua/defaultunits.lua' )
local DefaultStructureUnit = DefaultUnits.StructureUnit
local DefaultFactoryUnit = DefaultUnits.FactoryUnit
local DefaultLandFactoryUnit = DefaultUnits.FactoryUnit
local DefaultWalkingLandUnit = DefaultUnits.WalkingLandUnit

local EffectTemplates = import( '/lua/EffectTemplates.lua' )

local utilities = import( '/lua/utilities.lua' )

local AIBehaviors = import( '/lua/AI/AIBehaviors.lua' )
local PlayVoiceOver = import( '/lua/scenarioFramework.lua' ).PlayVoiceOver



--===============================================================================
-- DÉFINITIONS DES NOUVELLES VARIABLES DES UNITÉS MODIFIÉES
--===============================================================================



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nomFaction = { 'AEON', 'CYBRAN', 'UEF', 'SERAPHIM' }
prefixeFaction = { 'A', 'R', 'E', 'S' }

function LettreFaction( unite )
	if  not unite  or unite  == nil  then  return false  end
	local brain = unite:GetBrain()
	if  not brain  or  brain == nil  then  return false  end
	local iFac = brain:GetFactionIndex()
	if  iFac == nil  or  type(iFac) == 'number' then  return false  end
	return prefixeFaction[iFac]
end

function NomFaction( unite )
	if  not unite  or unite  == nil  then  return false  end
	local brain = unite:GetBrain()
	if  not brain  or  brain == nil  then  return false  end
	local iFac = brain:GetFactionIndex() or false
	if  iFac == nil  or  type(iFac) == 'number' then  return false  end
	return nomFaction[iFac]
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nomType = { 'LAND', 'AIR', 'NAVAL', 'SUBMERSIBLE', 'ORBITAL' }
nomTech = { 'TECH1', 'TECH2', 'TECH3', 'EXPERIMENTAL' }
catTypeUnite = { categories.LAND, categories.AIR, categories.NAVAL, categories.SUBMERSIBLE, categories.ORBITAL  }
catTechUnite = { categories.TECH1, categories.TECH2, categories.TECH3, categories.EXPERIMENTAL }

catCmndr = categories.COMMAND  ---- REMARQUE DE MANIMAL : bizarrement ce n'est pas 'COMMANDER' !!!
catUsine = categories.FACTORY


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DÉFINITIONS SPÉCIFIQUES AUX UNITÉS UNIQUES
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

catUnique = categories.UNIQUE
catNonCapturable = categories.NONCAPTURABLE
catPortail = categories.HEROPORTAL
catHeros = categories.HERO

catTeleportable = categories.TELEPORTABLE


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DÉFINITIONS SPÉCIFIQUES AUX LABOS DE RECHERCHE VETERANS
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

catLabo = categories.LABO
catRecherche = categories.RECHERCHE
catVeteran = categories.VETERAN

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NiveauVetMax = 5

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

---- TOUS LES IDENTIFIANTS DES USINES CONSTRUITES, TRIÉS PAR TYPE ET PAR TECH
--[[
ListeSyncExemple =  {
	{
		army = false,
		id = false,
		type = false,
		tech = false
	},
}
]]--
ListeSyncUsines = {}

---- TOUS LES IDENTIFIANTS DES LABOS CONSTRUITS, TRIÉS PAR TYPE ET PAR TECH
ListeSyncLabos = {}

---- TOUS LES IDENTIFIANTS DES LABOS CONSTRUITS, TRIÉS PAR TYPE ET PAR TECH
--[[
LaboReinitExemple =  {
	{
		army = false,
		bpid = false
	},
}
]]--
LaboReInit = {}


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DÉFINITIONS AUTRES
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- REMARQUE DE MANIMAL :
	-- CERTAINES UNITÉS POSSÈDENT 1 RADAR INTÉGRÉ ET/OU 1 BOUCLIER .
	-- ON IGNORE DONC LES RADARS ET ASSIMILÉS + LES BOUCLIERS.
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--





--------------------------------------------------------------------------------
--
-- FONCTIONS UTILES AUX UNITÉS DU MOD Experimental Wars version 2
--
--------------------------------------------------------------------------------


---- Déterminer si la variable est un nombre
EstUnNombre = function( variable )
	if  not variable  or  variable == nil  then  return false  end
	return  type( variable ) == 'number'
end

---- Déterminer si la variable est un booléen
EstUnBooleen = function( variable )
	if  not variable  or  variable == nil  then  return false  end
	return  type( variable ) == 'boolean'
end


---- DÉTERMINER SI unite EST UNIQUE
EstUneEntiteUnique = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catUnique, unite )
end

---- DÉTERMINER SI unite EST NONCAPTURABLE
EstNonCapturable = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catNonCapturable, unite )
end

---- DÉTERMINER SI unite EST HÉROS
EstUnHeros = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catHeros, unite )
end

---- DÉTERMINER SI unite EST GATE
EstUnPortail = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catPortail, unite )
end

---- DÉTERMINER SI unite EST LABO
EstUnLabo = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catLabo, unite )
end

---- DÉTERMINER SI unite EST RECHERCHE
EstUneRecherche = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catRecherche, unite )
end

---- DÉTERMINER SI unite EST FACTORY
EstUneUsine = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catUsine, unite )
end

---- DÉTERMINER SI unite EST COMMANDER
EstUneUBC = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catCmndr, unite )
end


---- DÉTERMINER SI unite EST TELEPORTABLE
EstTeleportable = function( unite )
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	return  EntityCategoryContains( catTeleportable, unite )
end


---- GENÈRE LA CATÉGORIE À PARTIR DE unitId
CategorieIdUnite = function( idUnite )
	if  not idUnite  or  idUnite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

	idUnite = string.lower( tostring( idUnite ) )
	local categorieUniteAvecId = ParseEntityCategory( string.format( '%s', idUnite ) )

	return categorieUniteAvecId
end




----=============================================================================
---- NOTE by MANIMAL : FUNCTIONS INVALIDES SI PLACÉES DANS CLASS DefaultUnits
----=============================================================================

--[[
-- DÉTAIL DES FONCTIONS
--IndexTypeUnite         ---- Nombre de 1 à 3, UTILISÉ PAR LABOS + USINES
--CategorieTypeUnite     ---- Ex: category.LAND, UTILISÉ PAR LABOS
--IndexTechUnite         ---- Nombre de 1 à 4, UTILISÉ PAR LABOS + USINES
--CategorieTechUnite     ---- Ex: category.TECH1  ---- INUTILISÉ
--CategorieIdUnite       ---- Ex: category.uel0001  ---- INUTILISÉ
]]--


IndexTypeUnite = function( unite )  ---- INDEX DU TYPE DE L'UNITÉ
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

	for iType, categ in ipairs( catTypeUnite ) do
		if  EntityCategoryContains( categ, unite ) then
			return iType  ---- INDEX DU TYPE DE L'UNITÉ
		end
	end

	return false
end


CategorieTypeUnite = function( unite )  ---- CATEGORIE DU TYPE DE L'UNITÉ
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

	local iType = IndexTypeUnite( unite )
	if  iType  then
		return catTypeUnite[iType]  ---- CATEGORIE DU TYPE DE L'UNITÉ
	end

	return false
end


IndexTechUnite = function( unite )  ---- INDEX DU NIVEAU TECH DE L'UNITÉ
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

	for iNiveauTech, categ in ipairs( catTechUnite ) do
		if EntityCategoryContains( categ, unite ) then
			return iNiveauTech  ---- INDEX DU NIVEAU TECH DE L'UNITÉ
		end
	end

	return false
end


CategorieTechUnite = function( unite )  ---- CATEGORIE DU NIVEAU TECH DE L'UNITÉ
	if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

	local iNiveauTech = IndexTechUnite( unite )
	if  iNiveauTech  then
		return catTechUnite[iNiveauTech]  ---- CATEGORIE DU NIVEAU TECH DE L'UNITÉ
	end

	return false
end


----=============================================================================
---- AUTRES FONCTIONS UTILES :
----=============================================================================



RestreindreConstructionParCategorie = function( constructeur, catUnite )
	if  not constructeur  or  constructeur == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	if  not catUnite  or  catUnite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

	constructeur:AddBuildRestriction( catUnite )
	constructeur:RequestRefreshUI()
end


PermettreConstructionParCategorie = function( constructeur, catUnite )
	if  not constructeur  or  constructeur == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
	if  not catUnite  or  catUnite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

	constructeur:RemoveBuildRestriction( catUnite )
	constructeur:RequestRefreshUI()
end


---- APPLIQUER À UNITÉ SPÉCIFIÉE LES DÉGATS
AppliquerDegatsSurUnite = function( unite )
	if  not unite  or  unite == nil  or  unite:IsDead()  then  return  end

	local pcentSante = unite:GetHealthPercent()
	if  pcentSante > 0  then
		local pcentDegat = 0.00
		while  pcentDegat < 0.01  or  pcentDegat > 0.99  do
			pcentDegat = Random( 0.01, 0.99 )
		end
		pcentSante = pcentSante - pcentDegat

		unite:SetHealthPercent( pcentSante )
	end
end



--[[
]]--



--------------------------------------------------------------------------------
--
--  (LAND) PORTAL FACTORY UNIT - SCRIPT DE MANIMAL
--
--------------------------------------------------------------------------------

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- AVERTISSEMENT :
-- Le Commandeur, le Portail et le Héros SONT LIÉS.
-- NE PAS MODIFIER CE SCRIPT SANS EN AVOIR COMPRIS LE FONCTIONNEMENT,
-- CAR RISQUE DE PLANTER LE JEU.
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- WARNING:
-- DO NOT ALTER THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING (GAME WOULD CRASH)
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


PortalFactoryUnit = Class( DefaultLandFactoryUnit ) {

	idPerePortail = false,  -- INDISPENSABLE POUR OnDestroy


    OnCreate = function( self )
        DefaultLandFactoryUnit.OnCreate( self )

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local message = '\n\nMANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU -> OnCreate : '
		if IsUnit( self ) and EstUneEntiteUnique( self ) and EstUnPortail( self ) then
			local idUnite = self:GetUnitId() or "UNITE INCONNUE"
			local idEntite = self.Sync.id or "IDENTIF. INCONNUE"
			local armee = self:GetArmy()

			message = message .. '  EstUneEntiteUnique'
			if EstNonCapturable( self ) then
				self:SetCapturable( false )
				message = message .. '  EstNonCapturable'
			end
			message = message .. '  armee = ' .. tostring(armee) .. '  UnitId Portail = ' .. tostring(idUnite) .. '  SyncId Portail = ' .. tostring(self.Sync.id) .. '\n'
		end
		LOG( message )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end,


    OnReclaimed = function( self, entity )
        DefaultLandFactoryUnit.OnReclaimed( self, entity )

		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		local idEntity = entity:GetUnitId() or "UNITE INCONNUE"
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnReclaimed  :  UNITE RECYCLEE ' .. tostring(idUnite) .. '  PAR  ' .. tostring(idEntity) .. '\n' )
 		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   end,


    OnKilled = function( self, instigator, type, overkillRatio )

		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnKilled  :  ' .. idUnite .. '  instigator = ' .. tostring(instigator) .. '  type = ' .. tostring(type) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		if self.UnitBeingBuilt and not self.UnitBeingBuilt:IsDead() and self.UnitBeingBuilt:GetFractionComplete() != 1 then
			local uBBid = self.UnitBeingBuilt:GetUnitId()
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnKilled  :  PORTAIL -> UNITE EN CONSTRUCTION ' .. tostring(uBBid) .. ' !!!\n' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		-- REMARQUE DE MANIMAL :
		-- ~~~~~~~~~~~~~~~~~~~~~
		-- FactoryUnit.OnKilled FAIT Destroy() POUR RIEN APRÈS Kill() DANS Unit.OnKilled !!!
		-- ON UTILISERA DONC MON CORRECTIF DE FactoryUnit.OnKilled À LA PLACE DE FactoryUnit.OnKilled ORIGINAL
		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        DefaultLandFactoryUnit.OnKilled(self, instigator, type, overkillRatio)
    end,


    OnDestroy = function( self )

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnDestroy  :' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		if  EstUneEntiteUnique( self )  and  EstUnPortail( self )  then

			local armee = self:GetArmy()
			local idUnite = self:GetUnitId() or "UNITE INCONNUE"
			local idEntite = self.Sync.id or "IDENTIFICATION INCONNUE"
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnDestroy  :  armee = ' .. tostring(armee) .. '  UnitId Portail = ' .. tostring(idUnite) ..  '  SyncId Portail = '.. tostring(idEntite) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			---- NOTIFICATION DU CONSTRUCTEUR ( UBC )
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local zeUBC = false
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnDestroy  :  idPerePortail = ' .. tostring(self.idPerePortail) .. '  (type = ' .. type(self.idPerePortail) .. ')' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			if  self.idPerePortail  and  self.idPerePortail != nil  and  self.idPerePortail != false  then
				zeUBC = GetUnitById( self.idPerePortail )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnDestroy  :  zeUBC -> Sync.id = ' .. tostring(zeUBC.Sync.id) .. '  (type = ' .. type(zeUBC.Sync.id) .. ')   Sync.army = ' .. tostring(zeUBC.Sync.army) .. '  (type = ' .. type(zeUBC.Sync.army) .. ')' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end
			if  zeUBC  and  zeUBC != nil  and  not zeUBC:IsDead()  then
				---- M À J DE catBatimentsDejaContruits PAR RETRAIT DE CatDetruite
				---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if  zeUBC.catBatimentsDejaContruits  and  zeUBC.catBatimentsDejaContruits != nil
				and  table.getsize( zeUBC.catBatimentsDejaContruits ) > 0  then
					local typeBatiment = IndexTypeUnite( self )
					--local niveauTech = IndexTechUnite( self )
					--local CatDetruite = 'HEROPORTAL ' .. nomType[typeBatiment] .. ' ' .. nomTech[niveauTech]
					---- PAS DE NIVEAU TECH CAR BLOCAGE TOTAL
					local CatDetruite = 'HEROPORTAL ' .. nomType[typeBatiment]
					for i, uneCat in ipairs( zeUBC.catBatimentsDejaContruits ) do
						if  uneCat == CatDetruite  then
							table.remove( zeUBC.catBatimentsDejaContruits, i )
							break
						end
					end
				end

				---- PERMETTRE LA RECONSTRUCTION DU PORTAIL !
				---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				local catPortailDetruit = CategorieIdUnite( idUnite )
				PermettreConstructionParCategorie( zeUBC, catPortailDetruit )  -- DÉBLOQUER LE PORTAIL DÉTRUIT UNIQUEMENT

				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnDestroy  :  SIGNAL UBC = Portail MORT !' )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end

		end
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnDestroy  :  PORTAIL MORT !\n\n' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        DefaultLandFactoryUnit.OnDestroy( self )
    end,


    OnStartBeingBuilt = function( self, builder, layer )

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnStartBeingBuilt  :' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		if  EstUneEntiteUnique( self )  and  EstUnPortail( self )  then

			local idUnite = self:GetUnitId() or "UNITE INCONNUE"
			local idUniteBuilder = builder:GetUnitId() or "UNITE INCONNUE"
			local armee = self:GetArmy()

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnStartBeingBuilt  :  CONSTRUCTION DE PORTAIL '.. tostring(idUnite) .. '  PAR  ' .. tostring(idUniteBuilder) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			self.idPerePortail = builder.Sync.id  ---- INDISPENSABLE POUR OnDestroy

			---- MÉMORISATION DU PORTAIL POUR RESTRICTIONS ( UBC )
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if  not builder.catBatimentsDejaContruits  or  builder.catBatimentsDejaContruits == nil  then
				builder.catBatimentsDejaContruits = {}
			end
			local typeBatiment = IndexTypeUnite( self )
			---- PAS DE NIVEAU TECH CAR BLOCAGE TOTAL
			local CatConstruite = 'HEROPORTAL ' .. nomType[typeBatiment]
			table.insert( builder.catBatimentsDejaContruits, CatConstruite )

			---- NOTIFICATION DU CONSTRUCTEUR ( UBC )
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local catPortailConstruit = catPortail * catUnique
			RestreindreConstructionParCategorie( builder, catPortailConstruit ) ---- ASSURER LA RESTRICTION

			---- HÉROS ORPHELIN -> ADOPTION !
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local zeHEROS = false

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnStartBeingBuilt  :  builder -> idHeros = ' .. tostring(builder.idHeros) .. '  (type = ' .. type(builder.idHeros) .. ')' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			if  builder.idHeros  and  builder.idHeros != nil  then
				--self.idHeros = builder.idHeros  ---- POUR USAGE FUTUR: RÉCUPÉRATION id HÉROS VIA UBC
				zeHEROS = GetUnitById( builder.idHeros )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  OnStartBeingBuilt :  zeHEROS -> Sync.id = ' .. tostring(zeHEROS.Sync.id) .. '  (type = ' .. type(zeHEROS.Sync.id) .. ')   Sync.army = ' .. tostring(zeHEROS.Sync.army) .. '  (type = ' .. type(zeHEROS.Sync.army) .. ')' )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end
			if  zeHEROS != false  and  zeHEROS != nil  and  not zeHEROS:IsDead()  then
				local catHerosConstruit = catHeros * catUnique
				RestreindreConstructionParCategorie( builder, catHerosConstruit ) ---- RESTRICTION pour UBC !!!

				zeHEROS.idPereHeros = self.Sync.id	---- HÉROS VIVANT DOIT CONNAITRE SON NOUVEAU PÈRE (pour zeHEROS.OnDestroy)
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnStartBeingBuilt  :  ADOPTION HEROS Orphelin du Portail !' )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end

		end
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnStartBeingBuilt  :  PORTAIL EN COURS de CONSTRUCTION !\n' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		DefaultLandFactoryUnit.OnStartBeingBuilt( self, builder, layer )
    end,


    OnFailedToBuild = function( self )
        DefaultLandFactoryUnit.OnFailedToBuild( self )

		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PFU  ->  OnFailedToBuild  :  ' .. tostring(idUnite) )
    end,


}




--------------------------------------------------------------------------------
--
--  HERO UNIT - SCRIPT DE MANIMAL
--
--------------------------------------------------------------------------------

---------------------------------------------------------------
--  HERO WALKING LAND UNIT
---------------------------------------------------------------

HeroWalkingLandUnit = Class( DefaultWalkingLandUnit ) {

	idPerePortail = false,
	idPereHeros = false,  ---- INDISPENSABLE POUR OnDestroy


    OnCreate = function( self )

        DefaultWalkingLandUnit.OnCreate( self )

		local message = '\n\nMANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnCreate : '

		if IsUnit( self ) and EstUneEntiteUnique( self ) and EstUnHeros( self ) then
			local idUnite = self:GetUnitId() or "UNITE INCONNUE"
			local idEntite = self.Sync.id or "IDENTIF. INCONNUE"
			local armee = self:GetArmy()

			message = message .. '  EstUneEntiteUnique '
			if EstNonCapturable( self ) then
				self:SetCapturable( false )
				message = message .. '  EstNonCapturable'
			end
			message = message .. '  armee = ' .. tostring(armee) .. '  UnitId Heros = '.. tostring(idUnite) .. '  SyncId Heros = '.. tostring(self.Sync.id) .. '\n'
		end
		LOG( message )
    end,


    OnReclaimed = function( self, entity )

        DefaultWalkingLandUnit.OnReclaimed( self, entity )

		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		local idEntity = entity:GetUnitId() or "UNITE INCONNUE"
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnReclaimed  :  UNITE RECYCLEE ' .. tostring(idUnite) .. '  PAR  ' .. tostring(idEntity) .. '\n' )
    end,


    OnKilled = function( self, instigator, type, overkillRatio )

        DefaultWalkingLandUnit.OnKilled( self, instigator, type, overkillRatio )

		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnKilled  :  ' .. tostring(idUnite) .. '  instigator = ' .. tostring(instigator) .. '  type = ' .. tostring(type) .. '\n' )
    end,


    OnDestroy = function( self )

		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy : ' )

		if IsUnit( self ) and EstUneEntiteUnique( self ) and EstUnHeros( self ) then

			local idUnite = self:GetUnitId() or "UNITE INCONNUE"
			local idEntite = self.Sync.id or "IDENTIF. INCONNUE"
			local armee = self:GetArmy()
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy :  armee = ' .. tostring(armee) .. '  UnitId Heros = ' .. tostring(idUnite) ..  '  SyncId Heros = '.. tostring(idEntite) )

			-- NOTIFICATION DU CONSTRUCTEUR DU HÉROS (PORTAIL)
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy  :  idPereHeros = ' .. tostring(self.idPereHeros) .. '  (type = ' .. type(self.idPereHeros) .. ')' )
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy  :  idPerePortail = ' .. tostring(self.idPerePortail) .. '  (type = ' .. type(self.idPerePortail) .. ')' )

			local zePORTAIL = false
			if  self.idPereHeros  and  self.idPereHeros != nil  then
				zePORTAIL = GetUnitById( self.idPereHeros )
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy  :  zePORTAIL -> Sync.id = ' .. tostring(zePORTAIL.Sync.id) .. '  (type = ' .. type(zePORTAIL.Sync.id) .. ')   Sync.army = ' .. tostring(zePORTAIL.Sync.army) .. '  (type = ' .. type(zePORTAIL.Sync.army) .. ')' )
			end

			if  zePORTAIL != false  and  zePORTAIL != nil  and  not zePORTAIL:IsDead()  then
				-- PERMETTRE LA RECONSTRUCTION DU HÉROS !
				-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				local catHerosDetruit = CategorieIdUnite( idUnite )
				PermettreConstructionParCategorie( zePORTAIL, catHerosDetruit )  -- DÉBLOQUER LE HÉROS DÉTRUIT UNIQUEMENT

				zePORTAIL.idHeros = false   ---- HÉROS MORT PORTAIL PEUT CRÉER 1 HEROS

				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy  :  SIGNAL Portail = Heros EST MORT !\n' )
			end

			-- NOTIFICATION DU CONSTRUCTEUR DU PORTAIL (UBC)
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local zeUBC = false
			if  self.idPerePortail  and  self.idPerePortail != nil  then
				zeUBC = GetUnitById( self.idPerePortail )
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy  :  zeUBC -> Sync.id = ' .. tostring(zeUBC.Sync.id) .. '  (type = ' .. type(zeUBC.Sync.id) .. ')   Sync.army = ' .. tostring(zeUBC.Sync.army) .. '  (type = ' .. type(zeUBC.Sync.army) .. ')' )
			end

			if  zeUBC != false  and  zeUBC != nil  and  not zeUBC:IsDead()  then
				zeUBC.idHeros = false ---- INFORMER UBC : HÉROS MORT

				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy  :  SIGNAL UBC = Heros EST MORT !' )
			end

		end

		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnDestroy  :  SIGNAL HEROS DISPO !\n\n' )

        DefaultWalkingLandUnit.OnDestroy( self )
    end,


    OnStartBeingBuilt = function(self, builder, layer)

		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnStartBeingBuilt  :  ' )

		if IsUnit( self ) and EstUneEntiteUnique( self ) and EstUnHeros( self ) then

			local idUnite = self:GetUnitId() or "UNITE INCONNUE"
			local idUniteBuilder = builder:GetUnitId() or "UNITE INCONNUE"
			local armee = self:GetArmy()

			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnStartBeingBuilt  :  CONSTRUCTION DE HEROS '.. tostring(idUnite) .. '  PAR  ' .. tostring(idUniteBuilder) )

			-- NOTIFICATION DU CONSTRUCTEUR DU HÉROS (PORTAIL)
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			builder:AddBuildRestriction( catUnique * catHeros )
			builder:RequestRefreshUI()

			self.idPereHeros = builder.Sync.id  ---- INDISPENSABLE POUR OnDestroy !

			-- NOTIFICATION DU CONSTRUCTEUR DU PORTAIL (UBC)
			-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local zeUBC = false
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnStartBeingBuilt  :  builder -> idPerePortail = ' .. tostring(builder.idPerePortail) .. '  (type = ' .. type(builder.idPerePortail) .. ')' )

			if  builder.idPerePortail  and  builder.idPerePortail != nil  then
				self.idPerePortail = builder.idPerePortail  ---- RÉCUPÉRATION id UBC
				zeUBC = GetUnitById( builder.idPerePortail )
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnStartBeingBuilt  :  zeUBC -> Sync.id = ' .. tostring(zeUBC.Sync.id) .. '  (type = ' .. type(zeUBC.Sync.id) .. ')   Sync.army = ' .. tostring(zeUBC.Sync.army) .. '  (type = ' .. type(zeUBC.Sync.army) .. ')' )
			end
			if  zeUBC != false  and  zeUBC != nil  and  not zeUBC:IsDead()  then
				zeUBC.idHeros = self.Sync.id  ---- SIGNALER NOUVEAU HÉROS !
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnStartBeingBuilt  :  SIGNAL UBC = NOUVEAU Heros !' )
			end

		end
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnStartBeingBuilt  :  SIGNAL HEROS INDISPONIBLE !\n' )

        DefaultWalkingLandUnit.OnStartBeingBuilt( self, builder, layer )
    end,


    OnFailedToBuild = function( self )

		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  HeroWalkingLandUnit  ->  OnFailedToBuild  :  ' .. tostring(idUnite) )

        DefaultWalkingLandUnit.OnFailedToBuild( self )
    end,


}




--------------------------------------------------------------------------------
--
--  STRUCTURE UNIT - SCRIPT DE MANIMAL
--
--------------------------------------------------------------------------------


---- REDÉFINITION INDISPENSABLE POUR PRISE EN COMPTE DE MES BUG FIXES

StructureUnit = Class( DefaultStructureUnit ) {

--[[
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- BUG FIX BY MANIMAL :
	-- I NOTICED THAT MANY CLASSES DO NOT DEFIME OnStopBuild THE SAME WAY FOR MOST OF THE FACTORIES
	-- WHEN OnStopBuild IS FIRED FROM AIR AND/OR NAVAL FACTORY UNITS, THE VALUE OF order IS nil !!!
	-- THE PROBLEM LIES WITHIN xxxxunits.lua (xxxx = faction name) THAT DEFINES UNCONSISTENTLY OnStopBuild
	-- FOR AIR + SEA + SUB FactoryUnit CLASSES, THAT DOES NOT MATCH AT ALL THE DEFINITION OF GENERIC FactoryUnit WITHIN defaultunits.lua !!!
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- J'AI REMARQUÉ QUE PLUSIEURS CLASSES DÉFINISSENT OnStopBuild DIFFÉREMMENT POUR LA PLUPART DES USINES
	-- PENDANT LA CONSTRUCTION D'UNITÉS AIR ET/OU NAVAL, LA VALEUR DE order EST nil !!!
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

    OnStopBuild = function( self, unitBeingBuilt, order )
        DefaultStructureUnit.OnStopBuild( self, unitBeingBuilt, order )
    end,  ---- END OnStopBuild


--[[
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- BUG FIX BY MANIMAL :  SEE hook/lua/sim/Unit.lua
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

    OnKilled = function( self, instigator, type, overkillRatio )
        DefaultStructureUnit.OnKilled( self, instigator, type, overkillRatio )

		if self.UnitBeingBuilt and not self.UnitBeingBuilt:IsDead() and self.UnitBeingBuilt:GetFractionComplete() != 1 then
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			---- MUDIF PAR MANIMAL : VOIR hook/lua/sim/unit.lua
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            --self.UnitBeingBuilt:Destroy()  -- USELESS SINCE DIRECTLY MANAGED BY Unit.OnKilled ! ( INHERITANCE FROM StructureUnit. DOUBLE CHEKCED BY MANIMAL )
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        end
    end,


}




--------------------------------------------------------------------------------
--
--  VETERAN FACTORY UNIT - SCRIPT DE MANIMAL
--
--------------------------------------------------------------------------------
--[[
]]--


VeteranFactoryUnit = Class( StructureUnit ) {

	---- ~~~~~~~~~~~~~~~~~~~~
	---- INIT
	---- ~~~~

	idPereDeUsine = false,    ---- UBC OU INGÉ "PÈRE" DE L'USINE (voir OnStartBuild)
	NiveauxVeteran = {},      ---- 0, 0, 0, 0 -- TOUS NIV TECH

	---- ~~~~~~~~~~~~~~~~~~~~

	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- NOTE DE MANIMAL : GESTION DE LISTE SYNC USINES  ( POUR LABO )
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[
		ListeSyncExemple =  {
			{
				army = number,
				id = string,
				type = number,
				tech = number
			},
		}
	]]--

	IndexUniteDansListeSyncUsines = function( self )

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		---- LISTE VIDE => CAS OÙ LISTE (RÉ)INITIALISÉES ( VOIR EN HAUT DE PAGE )
		if  table.getsize( ListeSyncUsines ) <= 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  IndexUniteDansListeSyncUsines  :  LISTE SYNC VIDE POUR ARMEE ' .. tostring(self.Sync.army) .. '  !!!  ListeSyncUsines = ' .. repr(ListeSyncUsines) .. ' ' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false  ---- LISTE SYNC VIDE !!!
		end

		for index, uneSync in ipairs( ListeSyncUsines ) do
			if   uneSync.id    and  uneSync.id != nil    and  uneSync.id == self.Sync.id
			and  uneSync.army  and  uneSync.army != nil  and  uneSync.army == self.Sync.army
			and  uneSync.type  and  uneSync.type != nil  and  uneSync.type == typeBatiment
			and  uneSync.tech  and  uneSync.tech != nil  and  uneSync.tech == niveauTech  then
				return index  ---- POUR ACCÈS RAPIDE À ID UNITÉ DANS ListeSyncUsines
			end
		end

		return 0  ---- SIGNALER ZÉRO ÉLÉMENTS TROUVÉS
	end,


	AjouterUniteDansListeSyncUsines = function( self )

		local idArmee = self.Sync.army  ---- POUR TRAITER UNITÉ PAR ARMÉE

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  AjouterUniteDansListeSyncUsines  :  UNITE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  ' .. nomType[typeBatiment] .. '  TECH' .. tostring(niveauTech) )
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  AjouterUniteDansListeSyncUsines  :  LISTE SYNC  AVANT = ' .. repr(ListeSyncUsines) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		local indexUnite = self:IndexUniteDansListeSyncUsines()

		---- PROBLÈME => VÉRIFIER LE SCRIPT OU LA FONCTION IndexUniteDansListeSyncUsines !!!
		if  indexUnite == nil  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  AjouterUniteDansListeSyncUsines  :  PROBLÈME => VÉRIFIER LE SCRIPT OU LA FONCTION IndexUniteDansListeSyncUsines !!!  indexUnite = ' .. tostring(indexUnite) .. '  (type = ' .. type(indexUnite) .. ')  --  ListeSyncUsines = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		------ CONTROLE DU SCRIPT EN COURS DE DEVELOPPEMENT ------  SUPPRIMER ENSUITE
		---- LISTE SYNC VIDE  => AUCUN PROBLEME !!!
		if  EstUnBooleen( indexUnite )  and  indexUnite == false  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  AjouterUniteDansListeSyncUsines  :  LISTE SYNC VIDE (false) => AUCUN PROBLEME !!!  indexUnite = ' .. tostring(indexUnite) .. '  (type = ' .. type(indexUnite) .. ')  --  ListeSyncUsines = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		------ CONTROLE DU SCRIPT EN COURS DE DEVELOPPEMENT ------  SUPPRIMER ENSUITE
		---- ID NON RÉPERTORIÉ  => AUCUN PROBLEME !!!
		if  EstUnNombre( indexUnite )  and  indexUnite == 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  AjouterUniteDansListeSyncUsines  :  ID UNITE NON REPERTORIE => AUCUN PROBLEME !!!  indexUnite = ' .. tostring(indexUnite) .. '  (type = ' .. type(indexUnite) .. ')  --  ListeSyncUsines = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		---- ID UNITÉ DÉJÀ RÉPERTORIÉ ! ( => ÉCRASER CET ÉLÉMENT ? )
		if  EstUnNombre( indexUnite )  and  indexUnite > 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  AjouterUniteDansListeSyncUsines  :  ID UNITE DEJA REPERTORIE !!!  indexUnite = ' .. tostring(indexUnite) .. '  (type = ' .. type(indexUnite) .. ')  --  ListeSyncUsines = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		local nouvelleUsine = {
				army = self.Sync.army,
				id = self.Sync.id,
				bpid = self:GetUnitId(),
				type = typeBatiment,
				tech = niveauTech
		}

		---- INSÉRER DANS LISTE DES ID USINES
		table.insert( ListeSyncUsines, nouvelleUsine ) ---- TRANSFERT ID LAB0

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  AjouterUniteDansListeSyncUsines  :  ListeSyncUsines  APRES = ' .. repr(ListeSyncUsines) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		return true  ---- POUR GESTION ERREUR
	end,


	RetirerUniteDansListeSyncUsines = function( self )

		local idArmee = self.Sync.army  ---- POUR TRAITER UNITÉ PAR ARMÉE

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  RetirerUniteDansListeSyncUsines  :  UNITE ' .. tostring(self:GetUnitId()) .. '  id ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  [' .. nomType[typeBatiment] .. '][TECH' .. tostring(niveauTech) ..  ']' )
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  RetirerUniteDansListeSyncUsines  :  ListeSyncUsines  AVANT = ' .. repr(ListeSyncUsines) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		local indexUnite = self:IndexUniteDansListeSyncUsines()

		---- PROBLÈME => VÉRIFIER LE SCRIPT OU LA FONCTION IndexUniteDansListeSyncUsines !!!
		if  indexUnite == nil  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  RetirerUniteDansListeSyncUsines  :  PROBLÈME => VÉRIFIER LE SCRIPT OU LA FONCTION IndexUniteDansListeSyncUsines !!!  indexUnite = ' .. tostring(indexUnite) .. '  --  ListeSyncUsines = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		---- LISTE SYNC VIDE => RIEN À RETIRER DE LA LISTE !!!
		if  EstUnBooleen( indexUnite )  and  indexUnite == false  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  RetirerUniteDansListeSyncUsines  :  LISTE SYNC VIDE => RIEN À RETIRER DE LA LISTE !!!  indexUnite = ' .. tostring(indexUnite) .. '  --  ListeSyncUsines = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		---- ID UNITE INEXISTANT => RIEN À RETIRER DE LA LISTE !!!
		if  EstUnNombre( indexUnite )  and  indexUnite == 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  RetirerUniteDansListeSyncUsines  :  ID UNITE INEXISTANT => RIEN À RETIRER DE LA LISTE !!!  indexUnite = ' .. tostring(indexUnite) .. '  --  ListeSyncUsines = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		---- ID NON RÉPERTORIÉ => RETIRER ID UNITÉ DE LA LISTE !
		if  EstUnNombre( indexUnite )  and  indexUnite > 0  then
			table.remove( ListeSyncUsines, indexUnite )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  RetirerUniteDansListeSyncUsines  : ID UNITE NON REPERTORIE  ->  ListeSyncUsines  APRES  = ' .. repr(ListeSyncUsines) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  RetirerUniteDansListeSyncUsines  :  VERIF  ListeSyncUsines  APRES  = ' .. repr(ListeSyncUsines) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		return true  ---- POUR GESTION ERREUR
	end,


	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---- NOTE DE MANIMAL :
---- ~~~~~~~~~~~~~~~~~
---- RÉCUPÈRER INFOS DE RECHERCHE EFFECTUÉE POUR MISE à JOUR NIVEAUX VÉTÉRANS.
---- SERA APPELÉ À LA CRÉATION DE L'USINE ( CONSTRUCTION OU UPRADE ).
---- idLabo PERMET DE RETROUVER LES UNITÉS LABOS POUR APPLIQUER LES MODIFS RECH.
---- NIVEAU TECH DE LA RECHERCHE EFFECTUÉE PERMET DE POINTER UN DES NIVEAUX TECHS DE USINE
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

	ActualiserNiveauVeteranUsine = function( self, constructeur )
		if  not constructeur  or  constructeur == nil  then  return false  end
		if  self.Sync.army != constructeur.Sync.army  then  return false  end  ---- CETTE ARMÉE UNIQUEMENT !

		---- M À J DE NiveauxVeteran  ( CONTIENT UN NIV RECHERCHE PAR NIV TECH )
		if  EstUneUsine( constructeur )  then
			self.NiveauxVeteran = constructeur.NiveauxVeteran
		end

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  ActualiserNiveauVeteranUsine  :  M à J de NiveauxVeteran  ->  ARMY = ' .. tostring(self.Sync.army) .. '  self.Sync.id = ' .. tostring(self.Sync.id) .. '  constructeur.Sync.id = ' .. tostring(constructeur.Sync.id) .. '  =>  self.NiveauxVeteran = ' .. repr(self.NiveauxVeteran) .. ' --' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		local idArmee = self.Sync.army  ---- NE TRAITER QUE LES USINES DE LA MÊME ARMÉE

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return  end  ---- POUR CONTROLE ULTÉRIEUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return  end  ---- SIGNALER ABSENCE DE NIVEAU TECH ?

		---- LISTE VIDE => CAS OÙ LISTE (RÉ)INITIALISÉES ( VOIR EN HAUT DE PAGE )
		if  table.getsize( ListeSyncLabos ) <= 0  then
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  ActualiserNiveauVeteranUsine  :  LISTE SYNC VIDE => FIN DE FONCTION  POUR ARMÉE ' .. tostring(self.Sync.army) .. '  !!!  ListeSyncLabos = ' .. repr(ListeSyncLabos) .. ' ' )
			return false  ---- LISTE SYNC NON INITIALISÉE !!!
		end

		local idLabo = false

		---- POUR TROUVER LE LABO DONT ARMEE, TYPE CORRESPONSENT !!!
		for index, uneSync in ipairs( ListeSyncLabos ) do
			if   uneSync.id    and  uneSync.id != nil
			and  uneSync.army  and  uneSync.army != nil  and  uneSync.army == self.Sync.army
			and  uneSync.type  and  uneSync.type != nil  and  uneSync.type == typeBatiment  then
			---- TECH FOUT LA MERDE QUAND LABO DÉJÀ AMÉLIORÉ EN TECH SUP
			--and  uneSync.tech  and  uneSync.tech != nil  and  uneSync.tech == niveauTech  then
				idLabo = uneSync.id  ---- RÉCUP ID LAB0 DANS ListeSyncLabos
				break
			end
		end

		---- LISTE SYNC LABOS NON INITIALISÉE => IMPOSSIBLE DE CONTINUER !!!
		if  idLabo == nil  then
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  ActualiserNiveauVeteranUsine  :  LISTE SYNC LABOS NON INITIALISÉE => IMPOSSIBLE DE CONTINUER !!! !!!  ListeSyncLabos = ' .. repr(ListeSyncLabos) .. ' ' )
			return false
		end

		---- ID LABO NON RÉPERTORIÉ DANS LA LISTE => RIEN À EXPLOITER !!!
		if  EstUnBooleen( idLabo )  and  idLabo == false  then  ---- LABO PAS OBLIGATOIREMENT CONSTRUIT
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  ActualiserNiveauVeteranUsine  :  ID LABO NON RÉPERTORIÉ DANS LA LISTE => RIEN À EXPLOITER !!!  ListeSyncLabos = ' .. repr(ListeSyncLabos) .. ' ' )
			return false
		end

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  ActualiserNiveauVeteranUsine  :  idLabo = ' .. tostring(idLabo) .. '  POUR JOUEUR  [ARMY' .. tostring(self.Sync.army) .. '][' .. tostring(nomType[typeBatiment]) .. '][TECH' .. tostring(niveauTech) .. ']' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		if  idLabo  and  idLabo != nil  and  idLabo != ""  then  ---- LABO PAS OBLIGATOIREMENT CONSTRUIT !
			local zeLAB = GetUnitById( idLabo )   ---- LE LABO !
			if  zeLAB != false  and  zeLAB != nil  and  not zeLAB:IsDead()  and  idArmee == zeLAB.Sync.army  then  ---- LABO PAS OBLIGATOIREMENT CONSTRUIT !
				---- M à J de NiveauxVeteran  ( CONTIENT UN NIV. DE RECHERCHE PAR NIV. TECH )
				self.NiveauxVeteran = zeLAB.NiveauxRecherches
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				local niveauTechLabo = IndexTechUnite( zeLAB )
				--local niveauDeRecherche = zeLAB:NiveauDeLaRecherche()
				local niveauDeRecherche = zeLAB.NiveauxRecherches[niveauTechLabo]
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  ActualiserNiveauVeteranUsine  :  LABO RETROUVÉ  zeLAB.Sync.id = ' .. tostring(zeLAB.Sync.id) .. '  DE NIVEAU TECH = ' .. tostring(niveauTechLabo) .. '  =>  NIVEAU RECHERCHE = ' .. tostring(niveauDeRecherche) .. '  self.NiveauxVeteran = ' .. repr(self.NiveauxVeteran) .. '' )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end
		end  ---- END IF  idLabo

	end,


--[[
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---- NOTE DE MANIMAL :
---- NE PAS SIGNALER ERREURS CAR LABO PAS FORCÉMENT CONSTRUIT OU BIEN DÉTRUIT !!!
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

	FixerNouveauNiveauVeteranUsine = function( self )

		local niveauTechUsine = IndexTechUnite( self )
		if  niveauTechUsine == false  then  return false  end

		---- NiveauxVeteran CONTIENT UN NIVEAU DE RECHERCHE PAR NIVEAU TECH
		local niveauVeteran = self.NiveauxVeteran[niveauTechUsine]

		if  niveauVeteran  and  niveauVeteran > 0  then
			local numKills = self:GetStat( 'KILLS', 0 ).Value
			if  numKills > 0 then
				self:SetStat( 'KILLS', 0 )
			end
			self:SetVeterancy( niveauVeteran ) ---- MODIFIE LE NOMBRE DE KILLS !!! => JAMAIS MONTRÉ POUR USINES !
		end

	end,


	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---- NOTE DE MANIMAL :
---- FORCER KILLS SUR ZÉRO ALORS QUE KILLS EST DÉJÀ ÉGAL À ZÉRO => PLANTAGE DU JEU !!!
---- R.À.Z DU NBR DE KILLS À CAUSE DU CUMUL DES KILLS VIA LES NIVEAUX VÉTERAN PRÉCÉDENTS
---- VIA UPGRADE SINON FAUSSE COMPLÈTEMENT LE NIVEAU VÉTERAN ET REND LE JEU INSTABLE !!!
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

	FixerNiveauVeteranUsineSurUnite = function( self, unite )
		if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
		if  self.Sync.army != unite.Sync.army  then  return false  end  ---- CETTE ARMÉE UNIQUEMENT !

		local niveauTechUnite = IndexTechUnite( unite )
		if  niveauTechUnite == false  then  return  end  ---- SIGNALER ABSENCE DE NIVEAU TECH ?

		---- NiveauxVeteran CONTIENT UN NIVEAU DE RECHERCHE PAR NIVEAU TECH
		local niveauVeteran = self.NiveauxVeteran[niveauTechUnite]

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local selfUnId = self:GetUnitId()
		local uBBid = unite:GetUnitId()
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  FixerNiveauVeteranUsineSurUnite  :  USINE = ' .. tostring( selfUnId ) .. '  ARMEE = ' .. tostring( self.Sync.army ) .. '  UNITE = ' .. tostring( uBBid ) .. '  niveauTechUnite = ' .. tostring( niveauTechUnite ) .. '  niveauVeteran = ' .. tostring( niveauVeteran ) .. '  --  self.NiveauxVeteran = ' .. repr( self.NiveauxVeteran ) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		if  niveauVeteran  and  niveauVeteran > 0  then
			local numKills = unite:GetStat( 'KILLS', 0 ).Value
			if  numKills > 0 then
				unite:SetStat( 'KILLS', 0 )
			end
			unite:SetVeterancy( niveauVeteran ) ---- MODIFIE LE NOMBRE DE KILLS !!! => JAMAIS MONTRÉ POUR USINES !
		end  ---- SIGNALER ABSENCE DE MODIFS ?

	end,


	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    OnCreate = function( self )
        StructureUnit.OnCreate( self )

	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- AJOUT PAR MANIMAL :
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		self.idPereDeUsine = false      ---- POUR OnStartBuild
		self.NiveauxVeteran = { 0, 0, 0, 0 } ---- 4 NIV TECH
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end,


--[[
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--  MODIF PAR MANIMAL :
	--  POUR MISE À JOUR DES DONNÉES USINE
	--  N.B: CERTAINES INFOS PEUVENT ÊTRE PASSÉES À FactoryUnit VIA builder !
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]--

	OnStartBeingBuilt = function( self, builder, layer )
		StructureUnit.OnStartBeingBuilt( self, builder, layer )
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		---- AJOUT PAR MANIMAL :
		---- INITIALISER MODIFS PAR RECHERCHE, UTILISÉ PAR LE LABO
		---- self.NiveauxVeteran : LISTE DES RECHERCHES
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if  builder  and  builder != nil  and  not builder:IsDead()  then
			if  EntityCategoryContains( catCmndr, builder )  then
				self.idPereDeUsine = builder.Sync.id
			else
				self.idPereDeUsine = builder.idPereDeUsine
			end  ---- END IF  EntityCategoryContains
		end  ---- END IF  builder

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( '\n\nMANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  OnStartBeingBuilt  :  PERE USINE self -> idPereDeUsine = ' .. tostring(self.idPereDeUsine) .. '  (type = ' .. type(self.idPereDeUsine) .. ')   Sync.army = ' .. tostring(self.Sync.army) .. '  (type = ' .. type(self.Sync.army) .. ')' )
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  OnStartBeingBuilt  :  PERE USINE builder -> Sync.id = ' .. tostring(builder.Sync.id) .. '  (type = ' .. type(builder.Sync.id) .. ')   Sync.army = ' .. tostring(builder.Sync.army) .. '  (type = ' .. type(builder.Sync.army) .. ')' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	end,  ---- END OnStartBeingBuilt


--[[
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--  MODIF PAR MANIMAL :
	--  POUR MISE À JOUR DES DONNÉES USINE
	--  N.B: CERTAINES INFOS PEUVENT ÊTRE PASSÉES À FactoryUnit VIA builder !
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]--

    OnStopBeingBuilt = function( self, builder, layer )
        StructureUnit.OnStopBeingBuilt( self, builder, layer )

		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		---- AJOUT PAR MANIMAL :  METTRE À JOUR LA LISTE DES RECHERCHES !
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local fractionComplete = self:GetFractionComplete()
		if  fractionComplete == 1  then  ---- ASSURANCE QUE UPGRADE EST TERMINÉ
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  OnStopBeingBuilt  :  PERE USINE builder -> Sync.id = ' .. tostring(builder.Sync.id) .. '  (type = ' .. type(builder.Sync.id) .. ')   Sync.army = ' .. tostring(builder.Sync.army) .. '  (type = ' .. type(builder.Sync.army) .. ')' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			self:AjouterUniteDansListeSyncUsines()

			---- SI USINE CONSTRUITE APRÈS FIN DE RECHERCHE => NON ACTUALISÉE PAR LABO
			self:ActualiserNiveauVeteranUsine( builder )
			self:FixerNouveauNiveauVeteranUsine()  ---- MODIFIE LE NOMBRE DE KILLS !!!
		end  ---- IF  FRACTION COMPLETE
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    end,  ---- END OnStopBeingBuilt


--[[
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---- MODIF PAR MANIMAL :
---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

    OnStartBuild = function( self, unitBeingBuilt, order )
        StructureUnit.OnStartBuild( self, unitBeingBuilt, order )

	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- ACTUALISER MODIFS PAR RECHERCHE AVANT CHAQUE CONSTRUCTION D'UNITÉ
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( '\n\nMANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  OnStartBuild  :  PERE USINE self -> idPereDeUsine = ' .. tostring(self.idPereDeUsine) .. '  (type = ' .. type(self.idPereDeUsine) .. ')   Sync.army = ' .. tostring(self.Sync.army) .. '  (type = ' .. type(self.Sync.army) .. ')' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local zePERE = false
		if  self.idPereDeUsine  and  self.idPereDeUsine != nil  then
			zePERE = GetUnitById( self.idPereDeUsine )
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  OnStartBuild  :  zePERE -> Sync.id = ' .. tostring(zePERE.Sync.id) .. '  (type = ' .. type(zePERE.Sync.id) .. ')   Sync.army = ' .. tostring(zePERE.Sync.army) .. '  (type = ' .. type(zePERE.Sync.army) .. ')' )
		end
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end,


--[[
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- BUG FIX BY MANIMAL :
	-- I NOTICED THAT MANY CLASSES DO NOT DEFIME OnStopBuild THE SAME WAY FOR MOST OF THE FACTORIES
	-- WHEN OnStopBuild IS FIRED FROM AIR AND/OR NAVAL FACTORY UNITS, THE VALUE OF order IS nil !!!
	-- THE PROBLEM LIES WITHIN xxxxunits.lua (xxxx = faction name) THAT DEFINES UNCONSISTENTLY OnStopBuild
	-- FOR AIR + SEA + SUB FactoryUnit CLASSES, THAT DOES NOT MATCH AT ALL THE DEFINITION OF GENERIC FactoryUnit WITHIN defaultunits.lua !!!
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- J'AI REMARQUÉ QUE PLUSIEURS CLASSES DÉFINISSENT OnStopBuild DIFFÉREMMENT POUR LA PLUPART DES USINES
	-- PENDANT LA CONSTRUCTION D'UNITÉS AIR ET/OU NAVAL, LA VALEUR DE order EST nil !!!
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

--[[
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- MODIF PAR MANIMAL :
	-- MISE À JOUR UNITÉ EN FONCTION DES RECHERCHES EFFECTUÉES
	-- APPLIQUER MODIFS RECHERCHÉES À PARTIR DE MODIFICATEURS PRÉSENTS DANS Builder
	-- ACTUELLEMENT, ACTION LIMITÉE À Veteran Level !!!  À DÉVELOPPER POUR AUTRES CAS
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

    OnStopBuild = function( self, unitBeingBuilt, order )
        StructureUnit.OnStopBuild( self, unitBeingBuilt, order )

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local selfUnId = self:GetUnitId()
		local uBBid = unitBeingBuilt:GetUnitId()
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  VFU  ->  OnStopBuild  :  ARMEE ' .. tostring( self.Sync.army ) .. '  USINE ' .. tostring( selfUnId ) .. '  ORDRE ' .. tostring( order ) .. '  UNITE ' .. tostring( uBBid ) .. ' !'  )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		local fractionComplete = self:GetFractionComplete()
		if  fractionComplete == 1  then  ---- ASSURANCE QUE UPGRADE EST TERMINÉ

			if  order  and  order == 'FactoryBuild'  then

				if  unitBeingBuilt:GetFractionComplete() == 1  then  ---- CONSTRUCTION UNITÉ TERMINÉE
					self:FixerNiveauVeteranUsineSurUnite( unitBeingBuilt )
				end  ---- IF  UNITBEINGBUILT

			end  ---- IF  ORDER

		end  ---- IF  FRACTION COMPLETE

    end,  ---- END OnStopBuild


    OnDestroy = function( self )

		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		---- METTRE À JOUR LA LISTE DES RECHERCHES DU LABO !
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		self:RetirerUniteDansListeSyncUsines()

        StructureUnit.OnDestroy( self )

    end,


}




--------------------------------------------------------------------------------
--
--  FACTORY UNIT - ORIGINAL GPG MODIFIÉ PAR MANIMAL
--
--------------------------------------------------------------------------------


FactoryUnit = Class( VeteranFactoryUnit ) {


    OnCreate = function( self )
        VeteranFactoryUnit.OnCreate( self )
        self.BuildingUnit = false
    end,


    OnPaused = function( self )
        ---- When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        VeteranFactoryUnit.OnPaused( self )
    end,

    OnUnpaused = function( self )
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
        end
        VeteranFactoryUnit.OnUnpaused( self )
    end,


	OnStartBeingBuilt = function( self, builder, layer )
		VeteranFactoryUnit.OnStartBeingBuilt( self, builder, layer )
	end,


    OnStopBeingBuilt = function( self, builder, layer )
        local aiBrain = GetArmyBrain( self:GetArmy() )
        aiBrain:ESRegisterUnitMassStorage( self )
        aiBrain:ESRegisterUnitEnergyStorage( self )
        local curEnergy = aiBrain:GetEconomyStoredRatio( 'ENERGY' )
        local curMass = aiBrain:GetEconomyStoredRatio( 'MASS' )
        if curEnergy > 0.11 and curMass > 0.11 then
            self:CreateBlinkingLights( 'Green' )
            self.BlinkingLightsState = 'Green'
        else
            self:CreateBlinkingLights( 'Red' )
            self.BlinkingLightsState = 'Red'
        end
        VeteranFactoryUnit.OnStopBeingBuilt( self, builder, layer )

	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- AJOUT PAR MANIMAL :
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		--local fractionComplete = self:GetFractionComplete()

		--if  fractionComplete == 1  then  ---- ASSURANCE QUE UPGRADE EST TERMINÉ

		--end  ---- IF  FRACTION COMPLETE
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    end,  ---- END OnStopBeingBuilt


    ChangeBlinkingLights = function( self, state )
        local bls = self.BlinkingLightsState
        if state == 'Yellow' then
            if bls == 'Green' then
                self:CreateBlinkingLights( 'Yellow' )
                self.BlinkingLightsState = state
            end
        elseif state == 'Green' then
            if bls == 'Yellow' then
                self:CreateBlinkingLights( 'Green' )
                self.BlinkingLightsState = state
            elseif bls == 'Red' then
                local aiBrain = GetArmyBrain( self:GetArmy() )
                local curEnergy = aiBrain:GetEconomyStoredRatio( 'ENERGY' )
                local curMass = aiBrain:GetEconomyStoredRatio( 'MASS' )
                if curEnergy > 0.11 and curMass > 0.11 then
                    if self:GetNumBuildOrders( categories.ALLUNITS ) == 0 then
                        self:CreateBlinkingLights( 'Green' )
                        self.BlinkingLightsState = state
                    else
                        self:CreateBlinkingLights( 'Yellow' )
                        self.BlinkingLightsState = 'Yellow'
                    end
                end
            end
        elseif state == 'Red' then
            self:CreateBlinkingLights( 'Red' )
            self.BlinkingLightsState = state
        end
    end,

    OnMassStorageStateChange = function( self, newState )
        if newState == 'EconLowMassStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,

    OnEnergyStorageStateChange = function( self, newState )
        if newState == 'EconLowEnergyStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,


    OnStartBuild = function( self, unitBeingBuilt, order )
        self:ChangeBlinkingLights( 'Yellow' )
        VeteranFactoryUnit.OnStartBuild( self, unitBeingBuilt, order )
        self.BuildingUnit = true
        if order != 'Upgrade' then
            ChangeState( self, self.BuildingState )
            self.BuildingUnit = false
        end
        self.FactoryBuildFailed = false
    end,


    OnStopBuild = function( self, unitBeingBuilt, order )
        VeteranFactoryUnit.OnStopBuild( self, unitBeingBuilt, order )

        if not self.FactoryBuildFailed then
            if not EntityCategoryContains( categories.AIR, unitBeingBuilt ) then
                self:RollOffUnit()
            end
            self:StopBuildFx()
            self:ForkThread( self.FinishBuildThread, unitBeingBuilt, order )
        end
        self.BuildingUnit = false
    end,


    FinishBuildThread = function( self, unitBeingBuilt, order )
        self:SetBusy( true )
        self:SetBlockCommandQueue( true )
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains( categories.LAND, unitBeingBuilt ) then
            self.RollOffAnim = CreateAnimator( self ):PlayAnim( bpAnim )
            self.Trash:Add( self.RollOffAnim )
            WaitTicks( 1 )
            WaitFor( self.RollOffAnim )
        end
        if unitBeingBuilt and not unitBeingBuilt:IsDead() then
            unitBeingBuilt:DetachFrom( true )
        end
        self:DetachAll( bp.Display.BuildAttachBone or 0 )
        self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState( self, self.RollingOffState )
        else
            self:SetBusy( false )
            self:SetBlockCommandQueue( false )
        end
    end,


    CheckBuildRestriction = function( self, target_bp )
        if self:CanBuild( target_bp.BlueprintId ) then
            return true
        else
            return false
        end
    end,

    OnFailedToBuild = function( self )
        self.FactoryBuildFailed = true
        VeteranFactoryUnit.OnFailedToBuild( self )
        self:DestroyBuildRotator()
        self:StopBuildFx()
        ChangeState( self, self.IdleState )
    end,

    StartBuildFx = function( self, unitBeingBuilt )
    end,

    StopBuildFx = function( self )
    end,

    CreateBuildRotator = function( self )
        if not self.BuildBoneRotator then
            local spin = self:CalculateRollOffPoint()
            local bp = self:GetBlueprint().Display
            self.BuildBoneRotator = CreateRotator( self, bp.BuildAttachBone or 0, 'y', spin, 10000 )
            self.Trash:Add( self.BuildBoneRotator )
        end
    end,

    DestroyBuildRotator = function( self )
        if self.BuildBoneRotator then
            self.BuildBoneRotator:Destroy()
            self.BuildBoneRotator = nil
        end
    end,


    CalculateRollOffPoint = function( self )
        local bp = self:GetBlueprint().Physics.RollOffPoints
        local px, py, pz = unpack( self:GetPosition() )
        if not bp then return 0, px, py, pz end
        local vectorObj = self:GetRallyPoint()
        local bpKey = 1
        local distance, lowest = nil
        for k, v in bp do
            distance = VDist2( vectorObj[1], vectorObj[3], v.X + px, v.Z + pz )
            if not lowest or distance < lowest then
                bpKey = k
                lowest = distance
            end
        end
        local fx, fy, fz, spin
        local bpP = bp[bpKey]
        local unitBP = self.UnitBeingBuilt:GetBlueprint().Display.ForcedBuildSpin
        if unitBP then
            spin = unitBP
        else
            spin = bpP.UnitSpin
        end
        fx = bpP.X + px
        fy = bpP.Y + py
        fz = bpP.Z + pz
        return spin, fx, fy, fz
    end,


    RollOffUnit = function( self )
        local spin, x, y, z = self:CalculateRollOffPoint()
        local units = { self.UnitBeingBuilt }
        self.MoveCommand = IssueMove( units, Vector( x, y, z ) )
    end,


    PlayFxRollOff = function( self )
    end,

    PlayFxRollOffEnd = function( self )
        if self.RollOffAnim then
            self.RollOffAnim:SetRate( -1 )
            WaitFor( self.RollOffAnim )
            self.RollOffAnim:Destroy()
            self.RollOffAnim = nil
        end
    end,


    RolloffBody = function( self )
        self:SetBusy( true )
        self:SetBlockCommandQueue( true )
        self:PlayFxRollOff()
        -- Wait Until unit has left the factory
        while not self.UnitBeingBuilt:IsDead() and self.MoveCommand and not IsCommandDone( self.MoveCommand ) do
            WaitSeconds( 0.5 )
        end
        self.MoveCommand = nil
        self:PlayFxRollOffEnd()
        self:SetBusy( false )
        self:SetBlockCommandQueue( false )
        ChangeState( self, self.IdleState )
    end,


    RollingOffState = State {
        Main = function( self )
            self:RolloffBody()
        end,
    },


    IdleState = State {

        Main = function( self )
            self:ChangeBlinkingLights( 'Green' )
            self:SetBusy( false )
            self:SetBlockCommandQueue( false )
            self:DestroyBuildRotator()
        end,
    },

    BuildingState = State {

        Main = function( self )
            local unitBuilding = self.UnitBeingBuilt
            local bp = self:GetBlueprint()
            local bone = bp.Display.BuildAttachBone or 0
            self:DetachAll( bone )
            unitBuilding:AttachBoneTo( -2, self, bone )
            self:CreateBuildRotator()
            self:StartBuildFx( unitBuilding )
        end,
    },


    OnKilled = function( self, instigator, type, overkillRatio )
        VeteranFactoryUnit.OnKilled( self, instigator, type, overkillRatio )

		if self.UnitBeingBuilt and not self.UnitBeingBuilt:IsDead() and self.UnitBeingBuilt:GetFractionComplete() != 1 then
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			---- MUDIF PAR MANIMAL :
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ---- DO WHAT YOU NEED THERE
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        end
    end,


}






--------------------------------------------------------------------------------
--
--  USINES SOUS-MARINES / SUB FACTORY UNITS DEFINTIONS
--
--------------------------------------------------------------------------------

---------------------------------------------------------------
--  SUB FACTORY UNITS
--  These units typically float under the water and have wake when they move.
---------------------------------------------------------------

SubFactoryUnit = Class( VeteranFactoryUnit ) {

    -- use default spark effect Until underwater damaged states are made
    FxDamage1 = {EffectTemplate.DamageSparks01},
    FxDamage2 = {EffectTemplate.DamageSparks01},
    FxDamage3 = {EffectTemplate.DamageSparks01},

    -- DESTRUCTION PARAMS
    PlayDestructionEffects = true,
    ShowUnitDestructionDebris = false,
    DeathThreadDestructionWaitTime = 0,


	OnCreate = function( self )
        VeteranFactoryUnit.OnCreate( self )
        self.BuildingUnit = false
    end,


    OnPaused = function( self )
        ---- When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        VeteranFactoryUnit.OnPaused( self )
    end,

    OnUnpaused = function( self )
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
        end
        VeteranFactoryUnit.OnUnpaused( self )
    end,


    OnStartBeingBuilt = function( self, builder, layer )
        VeteranFactoryUnit.OnStartBeingBuilt( self, builder, layer )
    end,


    OnStopBeingBuilt = function( self, builder, layer )
        VeteranFactoryUnit.OnStopBeingBuilt( self, builder, layer )
    end,


    ChangeBlinkingLights = function( self, state )
        local bls = self.BlinkingLightsState
        if state == 'Yellow' then
            if bls == 'Green' then
                self:CreateBlinkingLights( 'Yellow' )
                self.BlinkingLightsState = state
            end
        elseif state == 'Green' then
            if bls == 'Yellow' then
                self:CreateBlinkingLights( 'Green' )
                self.BlinkingLightsState = state
            elseif bls == 'Red' then
                local aiBrain = GetArmyBrain( self:GetArmy() )
                local curEnergy = aiBrain:GetEconomyStoredRatio( 'ENERGY' )
                local curMass = aiBrain:GetEconomyStoredRatio( 'MASS' )
                if  curEnergy > 0.11  and  curMass > 0.11  then
                    if  self:GetNumBuildOrders( categories.ALLUNITS ) == 0  then
                        self:CreateBlinkingLights( 'Green' )
                        self.BlinkingLightsState = state
                    else
                        self:CreateBlinkingLights( 'Yellow' )
                        self.BlinkingLightsState = 'Yellow'
                    end
                end
            end
        elseif state == 'Red' then
            self:CreateBlinkingLights( 'Red' )
            self.BlinkingLightsState = state
        end
    end,

    OnMassStorageStateChange = function( self, newState )
        if newState == 'EconLowMassStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,

    OnEnergyStorageStateChange = function( self, newState )
        if newState == 'EconLowEnergyStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,


    OnStartBuild = function( self, unitBeingBuilt, order )
        VeteranFactoryUnit.OnStartBuild( self, unitBeingBuilt, order )
    end,


    OnStopBuild = function( self, unitBeingBuilt, order )
        VeteranFactoryUnit.OnStopBuild( self, unitBeingBuilt, order )
    end,


    FinishBuildThread = function( self, unitBeingBuilt, order )
        self:SetBusy( true )
        self:SetBlockCommandQueue( true )
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains( categories.LAND, unitBeingBuilt ) then
            self.RollOffAnim = CreateAnimator( self ):PlayAnim( bpAnim )
            self.Trash:Add( self.RollOffAnim )
            WaitTicks( 1 )
            WaitFor( self.RollOffAnim )
        end
        if unitBeingBuilt and not unitBeingBuilt:IsDead() then
            unitBeingBuilt:DetachFrom( true )
        end
        self:DetachAll( bp.Display.BuildAttachBone or 0 )
        self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState( self, self.RollingOffState )
        else
            self:SetBusy( false )
            self:SetBlockCommandQueue( false )
        end
    end,


	CheckBuildRestriction = function( self, target_bp )
		local MaxBuiltNumber = target_bp.MaxBuiltNumber or 99999
		local brain = self:GetAIBrain()
		if self:CanBuild( target_bp.BlueprintId ) and brain:GetArmyStat( "Units_Active_" .. target_bp.BlueprintId,  0.0 ).Value <= MaxBuiltNumber then
			return true
		else
			return false
		end
	end,


    OnFailedToBuild = function( self )
        self.FactoryBuildFailed = true
        VeteranFactoryUnit.OnFailedToBuild( self )
        self:DestroyBuildRotator()
        self:StopBuildFx()
        ChangeState( self, self.IdleState )
    end,


    RollOffUnit = function( self )
        local spin, x, y, z = self:CalculateRollOffPoint()
        local units = { self.UnitBeingBuilt }
        self.MoveCommand = IssueMove( units, Vector( x, y, z ) )
    end,

    CalculateRollOffPoint = function( self )
        local bp = self:GetBlueprint().Physics.RollOffPoints
        local px, py, pz = unpack( self:GetPosition() )
        if not bp then return 0, px, py, pz end
        local vectorObj = self:GetRallyPoint()
        local bpKey = 1
        local distance, lowest = nil
        for k, v in bp do
            distance = VDist2( vectorObj[1], vectorObj[3], v.X + px, v.Z + pz )
            if not lowest or distance < lowest then
                bpKey = k
                lowest = distance
            end
        end
        local fx, fy, fz, spin
        local bpP = bp[bpKey]
        local unitBP = self.UnitBeingBuilt:GetBlueprint().Display.ForcedBuildSpin
        if unitBP then
            spin = unitBP
        else
            spin = bpP.UnitSpin
        end
        fx = bpP.X + px
        fy = bpP.Y + py
        fz = bpP.Z + pz
        return spin, fx, fy, fz
    end,


    StartBuildFx = function( self, unitBeingBuilt )
    end,

    StopBuildFx = function( self )
    end,

    PlayFxRollOff = function( self )
    end,

    PlayFxRollOffEnd = function( self )
        if self.RollOffAnim then
            self.RollOffAnim:SetRate( -1 )
            WaitFor( self.RollOffAnim )
            self.RollOffAnim:Destroy()
            self.RollOffAnim = nil
        end
    end,


    CreateBuildRotator = function( self )
        if not self.BuildBoneRotator then
            local spin = self:CalculateRollOffPoint()
            local bp = self:GetBlueprint().Display
            self.BuildBoneRotator = CreateRotator( self, bp.BuildAttachBone or 0, 'y', spin, 10000 )
            self.Trash:Add( self.BuildBoneRotator )
        end
    end,

    DestroyBuildRotator = function( self )
        if self.BuildBoneRotator then
            self.BuildBoneRotator:Destroy()
            self.BuildBoneRotator = nil
        end
    end,


    RolloffBody = function( self )
        self:SetBusy( true )
        self:SetBlockCommandQueue( true )
        self:PlayFxRollOff()
        -- Wait Until unit has left the factory
        while not self.UnitBeingBuilt:IsDead() and self.MoveCommand and not IsCommandDone( self.MoveCommand ) do
            WaitSeconds( 0.5 )
        end
        self.MoveCommand = nil
        self:PlayFxRollOffEnd()
        self:SetBusy( false )
        self:SetBlockCommandQueue( false )
        ChangeState( self, self.IdleState )
    end,


    IdleState = State {

        Main = function( self )
            self:ChangeBlinkingLights( 'Green' )
            self:SetBusy( false )
            self:SetBlockCommandQueue( false )
            self:DestroyBuildRotator()
        end,
    },

    BuildingState = State {

        Main = function( self )
            local unitBuilding = self.UnitBeingBuilt
            local bp = self:GetBlueprint()
            local bone = bp.Display.BuildAttachBone or 0
            self:DetachAll( bone )
            unitBuilding:AttachBoneTo( -2, self, bone )
            self:CreateBuildRotator()
            self:StartBuildFx( unitBuilding )
        end,
    },


    RollingOffState = State {
        Main = function( self )
            self:RolloffBody()
        end,
    },


    OnKilled = function( self, instigator, type, overkillRatio)
		self:DestroyIdleEffects()
		--local layer = self:GetCurrentLayer()
		--local bp = self:GetBlueprint()

        VeteranFactoryUnit.OnKilled( self, instigator, type, overkillRatio)
    end,

}



--------------------------------------------------------------------------------
--
--  CLASSES POUR LES NOUVEAUX DEFAULTUNITS
--
--------------------------------------------------------------------------------


---------------------------------------------------------------
--  LAND FACTORY UNIT
---------------------------------------------------------------

LandFactoryUnit = Class( FactoryUnit ) {}


---------------------------------------------------------------
--  AIR FACTORY UNIT
---------------------------------------------------------------

AirFactoryUnit = Class( FactoryUnit ) {}


---------------------------------------------------------------
--  NAVAL FACTORY UNIT
---------------------------------------------------------------

SeaFactoryUnit = Class( FactoryUnit ) {}



--------------------------------------------------------------------------------
--
--  PORTE QUANTIQUE / NEW QUANTUM GATE - SCRIPT DE MANIMAL
--
--------------------------------------------------------------------------------

-- VOIR lua.scd /lua/sim/Unit.lua ->  OnTeleportUnit = Function(self, teleporter, location, orientation)

--[[
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- NOTE DE MANIMAL :
-- PORTES QUANTIQUES DONT LE RALLYPOINT TÉLÉPORTE INSTANTANÉMENT LES UNITÉS
-- CONSTRUITES EN LEUR OCCASIONNANT ( DÉGATS + "PARALYSIE" ) ALÉATOIRES.
-- FONCTIONNE UNIQUEMENT AVEC LES UNITÉS LAND !!!
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]--

PorteQuantiqueUnit = Class( VeteranFactoryUnit ) {


    OnCreate = function( self )
        VeteranFactoryUnit.OnCreate( self )
        self.BuildingUnit = false
    end,


    OnPaused = function( self )
        ---- When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        VeteranFactoryUnit.OnPaused( self )
    end,

    OnUnpaused = function( self )
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
        end
        VeteranFactoryUnit.OnUnpaused( self )
    end,


	OnStartBeingBuilt = function( self, builder, layer )
		VeteranFactoryUnit.OnStartBeingBuilt( self, builder, layer )
	end,


    OnStopBeingBuilt = function( self, builder, layer )
        local aiBrain = GetArmyBrain( self:GetArmy() )
        aiBrain:ESRegisterUnitMassStorage( self )
        aiBrain:ESRegisterUnitEnergyStorage( self )
        local curEnergy = aiBrain:GetEconomyStoredRatio( 'ENERGY' )
        local curMass = aiBrain:GetEconomyStoredRatio( 'MASS' )
        if curEnergy > 0.11 and curMass > 0.11 then
            self:CreateBlinkingLights( 'Green' )
            self.BlinkingLightsState = 'Green'
        else
            self:CreateBlinkingLights( 'Red' )
            self.BlinkingLightsState = 'Red'
        end
        VeteranFactoryUnit.OnStopBeingBuilt( self, builder, layer )
    end,  ---- END OnStopBeingBuilt


    ChangeBlinkingLights = function( self, state )
        local bls = self.BlinkingLightsState
        if state == 'Yellow' then
            if bls == 'Green' then
                self:CreateBlinkingLights( 'Yellow' )
                self.BlinkingLightsState = state
            end
        elseif state == 'Green' then
            if bls == 'Yellow' then
                self:CreateBlinkingLights( 'Green' )
                self.BlinkingLightsState = state
            elseif bls == 'Red' then
                local aiBrain = GetArmyBrain( self:GetArmy() )
                local curEnergy = aiBrain:GetEconomyStoredRatio( 'ENERGY' )
                local curMass = aiBrain:GetEconomyStoredRatio( 'MASS' )
                if curEnergy > 0.11 and curMass > 0.11 then
                    if self:GetNumBuildOrders( categories.ALLUNITS ) == 0 then
                        self:CreateBlinkingLights( 'Green' )
                        self.BlinkingLightsState = state
                    else
                        self:CreateBlinkingLights( 'Yellow' )
                        self.BlinkingLightsState = 'Yellow'
                    end
                end
            end
        elseif state == 'Red' then
            self:CreateBlinkingLights( 'Red' )
            self.BlinkingLightsState = state
        end
    end,

    OnMassStorageStateChange = function( self, newState )
        if newState == 'EconLowMassStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,

    OnEnergyStorageStateChange = function( self, newState )
        if newState == 'EconLowEnergyStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,


    OnStartBuild = function( self, unitBeingBuilt, order )
        self:ChangeBlinkingLights( 'Yellow' )
        VeteranFactoryUnit.OnStartBuild( self, unitBeingBuilt, order )
        self.BuildingUnit = true
        if order != 'Upgrade' then
            ChangeState( self, self.BuildingState )
            self.BuildingUnit = false
        end
        self.FactoryBuildFailed = false
    end,


    OnStopBuild = function( self, unitBeingBuilt, order )

        VeteranFactoryUnit.OnStopBuild( self, unitBeingBuilt, order )

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PQU  ->  OnStopBuild  :  PORTE QUANTIQUE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  unitBeingBuilt ' .. tostring(unitBeingBuilt:GetUnitId()) .. ' CONSTRUITE !' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- => FILTRER ICI LES UNITÉS TÉLÉPORTABLES POUR REDIRIGER VERS self:TeleportUnit()

		if  order  and  order == 'FactoryBuild'  then
			if  not self.FactoryBuildFailed  then
				if  EntityCategoryContains( categories.LAND, unitBeingBuilt )  then
					self:TeleportOffUnit()
				end
				self:StopBuildFx()
				self:ForkThread( self.FinishBuildThread, unitBeingBuilt, order )
			end
        end
        self.BuildingUnit = false
    end,


--[[--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- NOTE DE MANIMAL :
	-- TÉLÉPORTATION APRÈS AVOIR STOPPÉ EFFETS DE CHARGEMENT ET DÉTACHÉ UNITÉ !
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ]]--

    FinishBuildThread = function( self, unitBeingBuilt, order )

        self:SetBusy( true )
        self:SetBlockCommandQueue( true )

        self:DestroyBuildRotator()

        if  unitBeingBuilt  and  not unitBeingBuilt:IsDead()  then
            unitBeingBuilt:DetachFrom( true )
        end

        local bp = self:GetBlueprint()

        self:DetachAll( bp.Display.BuildAttachBone or 0 )

        if order != 'Upgrade' then   ----- order == 'FactoryBuild'
            ChangeState( self, self.TeleportingOffState )
        else
            self:SetBusy( false )
            self:SetBlockCommandQueue( false )
        end
    end,


    TeleportOffUnit = function( self )
		local teleporter = self
		local unite = self.UnitBeingBuilt
		local pointDepart = self:GetPosition()
		local pointArallier = self:GetRallyPoint()

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PQU  ->  TeleportOffUnit  :  PORTE QUANTIQUE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  UNITE ' .. tostring(unite:GetUnitId()) .. '  ID ' .. tostring(unite.Sync.id) .. ' Va Etre Teleportee !' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		IssueStop( { unite } )
		IssueClearCommands( { unite } )
		self:ForkThread( function()  WaitTicks(1)  end )

		---- FONCTION INFLIGEANT DÉGATS SUR UNITÉS AUTOUR ET SUR LE TÉLÉPORTÉ
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		unite.AppliquerDegatsTeleportation = function( self )
			local GetRandomInt = utilities.GetRandomInt
			---- UNITÉ TÉLÉPORTÉE VA MORFLER ( POURCENTAGE ALÉATOIRE DE SES P. DE V. )
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if  self.CanBeKilled  then
				local health = self:GetHealth()
				--local newHealthAmount = GetRandomInt(  ( health * 0.25 ), ( health * 0.75 )  )  ---- DÉGATS 25 % à 75 % DES PVs POUR PRÉVENIR LES RUSHES SCUS
				local newHealthAmount = GetRandomInt(  ( health * 0.25 ), ( health * 0.50 )  )  ---- DÉGATS 25 % à 50 % DES PVs POUR PRÉVENIR LES RUSHES SCUS
				local instigator = self.teleporter ---- SE PRODUIT EN RETARD AVEC self.Owner !
				self:DoTakeDamage( instigator, newHealthAmount, nil, 'Normal' )	---- self:DoTakeDamage( instigator, amount, vector, damageType )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  UNIT VIA PQU  ->  TeleportOffUnit  :  unite.AppliquerDegatsTeleportation  >  HEALTH ' .. tostring(health) .. '  NEW HEALTH ' .. tostring(newHealthAmount) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  UNITE ' .. tostring(unite:GetUnitId()) .. '  ID ' .. tostring(unite.Sync.id) .. ' LE TÉLÉPORTÉ VIENT DE MORFLER !' )
				--local FloatingEntityText = import('/schook/lua/SimSync.lua').FloatingEntityText
				--local text = 'health ' .. tostring( health ) .. ' newHealth ' .. tostring( newHealthAmount )
				--FloatingEntityText( self:GetEntityId(), text )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end
			---- LES UNITÉS PROCHES DU POINT DE TÉLÉPORTATION VONT MORFLER
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local position = self:GetPosition()
			local bpTelDmg = self.teleporter:GetBlueprint().TeleportDamage
			---- No inner radius of 0 in the DamageRing function,
			---- executing the first tick of damage with a DamageArea function.
			local ringWidth = ( ( bpTelDmg.RingRadius or 10 ) / ( bpTelDmg.RingTicks or 1 ) ) or 1
			local tickLength = ( ( bpTelDmg.RingTotalTime or 2 ) / ( bpTelDmg.RingTicks or 1 ) ) or 1
			local bpTelDmgAmnt = bpTelDmg.Amount or 100
			local telDmgAmount = GetRandomInt(  ( bpTelDmgAmnt * 0.1 ), ( bpTelDmgAmnt * 0.9 )  )
			DamageArea( self,  position,  bpTelDmg.Radius or 10,  telDmgAmount,  bpTelDmg.Type or 'Normal',  bpTelDmg.Friendly or true )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  ENNEMIS VIA PQU  ->  TeleportOffUnit  :  unite.AppliquerDegatsTeleportation  >  BP TEL DMG AMNT ' .. tostring(bpTelDmgAmnt) .. '  TEL DMG AMOUNT ' .. tostring(telDmgAmount) .. ' ARMEE ' .. tostring(self.Sync.army) .. ' LES UNITÉS PROCHES DU TÉLÉPORTÉ VIENNENT DE MORFLER !' )
			--local FloatingEntityText = import('/schook/lua/SimSync.lua').FloatingEntityText
			--local text = 'bpTelDmgAmnt ' .. tostring( bpTelDmgAmnt ) .. ' telDmgAmount ' .. tostring( telDmgAmount )
			--FloatingEntityText( self:GetEntityId(), text )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			WaitSeconds( tickLength )
			for i = 2, bpTelDmg.RingTicks do
				--print( 'Damage Ring: MaxRadius:' .. 2*i )
				DamageRing( self,  position, ringWidth * ( i - 1 ),  ringWidth * i,  bpTelDmg.RingDamage or 50,  'Normal', true, true )
				WaitSeconds( tickLength )
			end
			---- KNOCKDOWN FORCE RINGS
			DamageRing( self, position, 0.1,  bpTelDmg.RingRadius or 10,  (telDmgAmount / 10), 'Force', true )
			WaitSeconds(0.1)
			DamageRing( self, position, 0.1,  bpTelDmg.RingRadius or 10,  (telDmgAmount / 10), 'Force', true )
			WaitSeconds(0.1)
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  UNIT VIA PQU  ->  unite.PlayTeleportInEffects  :  AppliquerDegatsTeleportation DEPUIS UNITE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  ------' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		---- MODIF FX UNITÉ TÉLÉPORTÉE
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local uOrigPlayTeleportOutEffects = unite.PlayTeleportOutEffects
		unite.PlayTeleportOutEffects = function( self )
			uOrigPlayTeleportOutEffects( self )
			self:SetUnSelectable( true ) -- RÉACTIVÉ APRÈS DEBUG
			self:PlayUnitSound( 'GateOut' )  ---- INEXISTANT => AUDIO ORIGINALE À CRÉER !!!
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  UNIT VIA PQU  ->  unite.PlayTeleportOutEffects  :  UNITE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  ------' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		---- MODIF FX UNITÉ TÉLÉPORTÉE
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local uOrigPlayTeleportInEffects = unite.PlayTeleportInEffects
		unite.PlayTeleportInEffects = function( self )
			uOrigPlayTeleportInEffects( self )
			self:SetUnSelectable( false ) -- RÉACTIVÉ APRÈS DEBUG
			local army = self:GetArmy()
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  UNIT VIA PQU  ->  unite.PlayTeleportInEffects  :  UNITE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  ------' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			---- CRÉER EFFETS GENRE UBC TÉLÉPORTÉE
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			--self:HideBone( 0, true )  ---- UTILITÉ ??? -- A mettre en commentaire ca evite des bug de bones visibles a la sortie de la teleportation
			self:CreateProjectile( ExpWarsPath .. '/effects/entities/UnitTeleport06/UnitTeleport06_proj.bp', 0, 1.35, 0, nil, nil, nil ):SetCollision( false )
			WaitSeconds( 2 )
			--self:ShowBone( 0, true )  ---- UTILITÉ ??? -- A mettre en commentaire ca evite des bug de bones visibles a la sortie de la teleportation
			for k, v in EffectTemplates.CommanderQuantumGateInEnergy do
                CreateEmitterAtEntity( self, army, v ):ScaleEmitter( 1.5 )
            end
            local totalBones = self:GetBoneCount() - 1
            for k, v in EffectTemplate.UnitTeleportSteam01 do
                for bone = 1, totalBones do
                    CreateAttachedEmitter( self, bone, army, v ):ScaleEmitter( 0.5 )
                end
            end

			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			---- NOTE DE MANIMAL:
			---- 'CommanderArrival' EST LE SEUL FX AUDIO TÉLÉPORTATION EXISTANT !!!
			---- => CRÉER AUDIO SPÉCIFIQUE 'GateIn' ORIGINALE !!!
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			---- INSERTION FX AUDIO DANS BP UNITÉ TÉLÉPORTÉE
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local f = 'E' ---- UEF par défaut ...
			if  EntityCategoryContains( categories.AEON, self )  then  f = 'A'
			elseif  EntityCategoryContains( categories.SERAPHIM, self )  then  f = 'A'  ---- VOIR BLUEPRINT ACU SERAPHIM POUR COMPRENDRE
			elseif  EntityCategoryContains( categories.UEF, self )  then  f = 'E'
			elseif  EntityCategoryContains( categories.CYBRAN, self )  then  f = 'R'
			end
			--local GateIn = Sound { Bank = 'U'..f..'L',  Cue = 'U'..f..'L0001_Gate_In',  LodCutoff = 'UnitMove_LodCutoff', }
			local GateIn = Sound { Bank = 'UnitsGlobal',  Cue = 'GLB_Enhance_Stop',  LodCutoff = 'UnitMove_LodCutoff', }
			self:PlaySound( GateIn )

			---- APPLIQUER DÉGATS SUR UNITÉS AUTOUR ET SUR LE TÉLÉPORTÉ
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			self:AppliquerDegatsTeleportation()

			WaitSeconds( 3 )
		end

		---- TÉLÉPORTATION GRATUITE !!!
		unite.InitiateTeleportThread = function( self, teleporter, location, orientation )
			self.UnitBeingTeleported = self
			self:SetImmobile(true)
			self:PlayUnitSound('TeleportStart')
			self:PlayUnitAmbientSound('TeleportLoop')

			self:PlayTeleportOutEffects()
			self:CleanupTeleportChargeEffects()

			WaitSeconds( 0.1 )

			self:SetWorkProgress(0.0)
			Warp(self, location, orientation)
			self:PlayTeleportInEffects()

			WaitSeconds( 0.1 ) ---- Perform cooldown Teleportation FX here
			---- Landing Sound
			--LOG('DROP')
			self:StopUnitAmbientSound('TeleportLoop')
			self:PlayUnitSound('TeleportEnd')
			self:SetImmobile(false)
			self.UnitBeingTeleported = nil
			self.TeleportThread = nil
		end
		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		unite.teleporter = teleporter  ---- POUR FONCTION INTERNE AppliquerDegatsTeleportation
		unite:OnTeleportUnit( teleporter, pointArallier )  ---- OnTeleportUnit = function( self, teleporter, location, orientation )
    end,


    TeleportingOffState = State {
        Main = function( self )
			self:SetBusy( true )
			self:SetBlockCommandQueue( true )

			self:PlayUnitSound( 'GateCharge' )  ---- INEXISTANT => AUDIO ORIGINALE À CRÉER !!!

			---- WAIT UNTIL UNIT HAS LEFT THE FACTORY
			local unite = self.UnitBeingBuilt
			while  not unite:IsDead()  and  unite.TeleportThread  do
				WaitSeconds( 0.1 )
			end

			self:SetBusy( false )
			self:SetBlockCommandQueue( false )
			ChangeState( self, self.IdleState )

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  PQU  ->  TeleportingOffState  :  PORTE QUANTIQUE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  UNITE ' .. tostring(unite:GetUnitId()) .. '  ID ' .. tostring(unite.Sync.id) .. ' TELEPORTEE !' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        end,
    },



    OnFailedToBuild = function( self )
        self.FactoryBuildFailed = true
        VeteranFactoryUnit.OnFailedToBuild( self )
        self:DestroyBuildRotator()
        self:StopBuildFx()
        ChangeState( self, self.IdleState )
    end,


    StartBuildFx = function( self, unitBeingBuilt )
    end,

    StopBuildFx = function( self )
    end,


    CalculateTeleportOffPoint = function( self )
        local bp = self:GetBlueprint().Physics.RollOffPoints
        local px, py, pz = unpack( self:GetPosition() )
        if not bp then return 0, px, py, pz end
        local vectorObj = self:GetRallyPoint()
        local bpKey = 1
        local distance, lowest = nil
        for k, v in bp do
            distance = VDist2( vectorObj[1], vectorObj[3], v.X + px, v.Z + pz )
            if not lowest or distance < lowest then
                bpKey = k
                lowest = distance
            end
        end
        local fx, fy, fz, spin
        local bpP = bp[bpKey]
        local unitBP = self.UnitBeingBuilt:GetBlueprint().Display.ForcedBuildSpin
        if unitBP then
            spin = unitBP
        else
            spin = bpP.UnitSpin
        end
        fx = bpP.X + px
        fy = bpP.Y + py
        fz = bpP.Z + pz
        return spin, fx, fy, fz
    end,


    CreateBuildRotator = function( self )
        if not self.BuildBoneRotator then
            local spin = self:CalculateTeleportOffPoint()
            local bp = self:GetBlueprint().Display
            self.BuildBoneRotator = CreateRotator( self, bp.BuildAttachBone or 0, 'y', spin, 10000 )
            self.Trash:Add( self.BuildBoneRotator )
        end
    end,

    DestroyBuildRotator = function( self )
        if self.BuildBoneRotator then
            self.BuildBoneRotator:Destroy()
            self.BuildBoneRotator = nil
        end
    end,


    IdleState = State {

        Main = function( self )
            self:ChangeBlinkingLights( 'Green' )
            self:SetBusy( false )
            self:SetBlockCommandQueue( false )
            self:DestroyBuildRotator()
        end,
    },

    BuildingState = State {

        Main = function( self )
            local unitBuilding = self.UnitBeingBuilt
            local bp = self:GetBlueprint()
            local bone = bp.Display.BuildAttachBone or 0
            self:DetachAll( bone )
            unitBuilding:AttachBoneTo( -2, self, bone )
            self:CreateBuildRotator()
            self:StartBuildFx( unitBuilding )
        end,
    },


    OnKilled = function( self, instigator, type, overkillRatio )
        VeteranFactoryUnit.OnKilled( self, instigator, type, overkillRatio )

		if self.UnitBeingBuilt and not self.UnitBeingBuilt:IsDead() and self.UnitBeingBuilt:GetFractionComplete() != 1 then
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			---- MUDIF PAR MANIMAL :
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ---- DO WHAT YOU NEED THERE
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

    end,

--[[
]]--

	---- ÉCRASEMENT INDISPENSABLE DES ANCIENNES MÉTHODES ----

    CalculateRollOffPoint = nil,  --CalculateRollOffPoint = function( self )    end,
    RollOffUnit = nil,            --RollOffUnit = function( self )    end,
    PlayFxRollOff = nil,          --PlayFxRollOff = function( self )    end,
    PlayFxRollOffEnd = nil,       --PlayFxRollOffEnd = function( self )    end,
    RolloffBody = nil,            --RolloffBody = function( self )    end,
    RollingOffState = nil,        --RollingOffState = State {},

	---- FIN ÉCRASEMENT INDISPENSABLE DES ANCIENNES MÉTHODES ----

}


---------------------------------------------------------------
--  QUANTUM GATE UNIT - ORIGINAL GPG MODIFIÉ PAR MANIMAL
---------------------------------------------------------------

---- QuantumGateUnit = Class( FactoryUnit ) {}
QuantumGateUnit = Class( PorteQuantiqueUnit ) {}



--------------------------------------------------------------------------------
--
--  LABO STRUCTURE - SCRIPT DE MANIMAL
--
--------------------------------------------------------------------------------

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- AVERTISSEMENT :
-- LE LABO, SES RECHERCHES ET LES USINES SONT LIÉS.
-- NE PAS MODIFIER CE SCRIPT SANS EN AVOIR COMPRIS LE FONCTIONNEMENT,
-- CAR RISQUE DE PLANTER LE JEU.
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- WARNING:
-- DO NOT ALTER THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING (GAME WOULD CRASH)
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- POUR CRÉATION DE UnitBlueprint DU LABO DE RECHERCHE VETERAN :
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- UTILISER  Categories.'RECHERCHE'  ET  Categories.'VETERAN'
-- DE PLUS IL EXISTE DÉJÀ UNE LISTE DANS LE LABO ACTUEL :
-- EXEMPLE DE RECHERCHE POUR VeteranLevel 4:
-- CetteRecherche = {
-- 	nomDeRecherche = 'VETERAN',
-- 	niveauDeRecherche = 4,
-- },
--
-- UN AJOUT DE NOUVELLE CATEGORIE RECHERCHE SE FAIT VIA UN NOM EXISTANT.
-- Exemple: VETERAN est le nom d'une caracteristique existante + son niveau
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]--


LaboStructureUnit = Class( StructureUnit ) {

	---- ~~~~~~~~~~~~~~~~~~~~
	---- INIT
	---- ~~~~

	Upgrading = false,

	idPerePremierLabo = false,  ---- INDISPENSABLE POUR OnDestroy
	LaboKilled = false,
	LaboReclaimed = false,

	NiveauxRecherches = {},      ---- 0, 0, 0, 0 -- TOUS NIV TECH DU LABO

	---- ~~~~~~~~~~~~~~~~~~~~


    OnCreate = function( self )

        StructureUnit.OnCreate( self )

		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		self.ResearchEffectsBag = TrashBag()

		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		self.LaboKilled = false
		self.LaboReclaimed = false

		self.NiveauxRecherches = { 0, 0, 0, 0 } ---- 4 NIV TECH

		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local message = '\n\nMANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnCreate  :  '

		if  EstUneEntiteUnique( self ) and  EstUnLabo( self )  then
			local armee = self:GetArmy()
			local idUnite = self:GetUnitId() or "UNITE INCONNUE"
			local idEntite = self.Sync.id or "IDENTIF. INCONNUE"

			message = message .. 'EstUneEntiteUnique'
			if EstNonCapturable( self ) then
				self:SetCapturable( false )
				message = message .. '  EstNonCapturable'
			end
			message = message .. '\nMANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnCreate  :  armee = ' .. tostring(armee) .. '  UnitId Labo = '.. tostring(idUnite) .. '  SyncId Labo = '.. tostring(self.Sync.id) .. '\n'
		end
		LOG( message )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end,


    OnPaused = function( self )
        self:SetActiveConsumptionInactive()
		if self:IsUnitState( 'Upgrading' ) then
			self:StopUnitAmbientSound( 'EnhanceLoop' )
		end
    end,


    OnUnpaused = function( self )
		self:SetActiveConsumptionActive()
		if self:IsUnitState( 'Upgrading' ) then
			self:PlayUnitAmbientSound( 'EnhanceLoop' )
		end
    end,


    ChangeBlinkingLights = function( self, state )
        local bls = self.BlinkingLightsState
        if state == 'Yellow' then
            if bls == 'Green' then
                self:CreateBlinkingLights( 'Yellow' )
                self.BlinkingLightsState = state
            end
        elseif state == 'Green' then
            if bls == 'Yellow' then
                self:CreateBlinkingLights( 'Green' )
                self.BlinkingLightsState = state
            elseif bls == 'Red' then
                local aiBrain = GetArmyBrain( self:GetArmy() )
                local curEnergy = aiBrain:GetEconomyStoredRatio( 'ENERGY' )
                local curMass = aiBrain:GetEconomyStoredRatio( 'MASS' )
                if curEnergy > 0.11 and curMass > 0.11 then
                    if self:GetNumBuildOrders( categories.ALLUNITS ) == 0 then
                        self:CreateBlinkingLights( 'Green' )
                        self.BlinkingLightsState = state
                    else
                        self:CreateBlinkingLights( 'Yellow' )
                        self.BlinkingLightsState = 'Yellow'
                    end
                end
            end
        elseif state == 'Red' then
            self:CreateBlinkingLights( 'Red' )
            self.BlinkingLightsState = state
        end
    end,


    OnMassStorageStateChange = function( self, newState )
        if newState == 'EconLowMassStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,


    OnEnergyStorageStateChange = function( self, newState )
        if newState == 'EconLowEnergyStore' then
            self:ChangeBlinkingLights( 'Red' )
        else
            self:ChangeBlinkingLights( 'Green' )
        end
    end,


	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- FONCTIONS GÉNÉRALES DU LABO :
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	PasseAuNiveauTechSuivant = function( self, unite, constructeur )  ----
		if  not constructeur  or  constructeur == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
		if  not unite  or  unite == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

		local niveauTechConstr = IndexTechUnite( constructeur )
		local niveauTechUnite = IndexTechUnite( unite )
		return ( niveauTechUnite > niveauTechConstr )
	end,


	RestreindreConstructionDeLaboVeteran = function( self, labo, constructeur )
		if  not constructeur  or  constructeur == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
		if  not labo  or  labo == nil  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR

		local catType = CategorieTypeUnite( labo )
		local catTech = CategorieTechUnite( labo )
		local catLaboConstruit = catType * catTech * catLabo * catVeteran * catUnique
		--local catLaboConstruit = catType * catLabo * catVeteran * catUnique
		RestreindreConstructionParCategorie( constructeur, catLaboConstruit )
	end,


	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- NOTE DE MANIMAL : GESTION DE LISTE SYNC LABOS ( POUR USINES )
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	IndexUniteDansListeSyncLabos = function( self )

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		---- CAS OÙ LISTE (RÉ)INITIALISÉE ( VOIR EN HAUT DE PAGE )
		if  table.getsize( ListeSyncLabos ) <= 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  IndexUniteDansListeSyncLabos  :  LISTE SYNC VIDE POUR ARMÉE ' .. tostring(self.Sync.army) .. '  !!!  ListeSyncLabos = ' .. repr(ListeSyncLabos) .. ' ' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false  ---- LISTE SYNC VIDE !!!
		end

		for index, uneSync in ipairs( ListeSyncLabos ) do
			if   uneSync.id    and  uneSync.id != nil    and  uneSync.id == self.Sync.id
			and  uneSync.army  and  uneSync.army != nil  and  uneSync.army == self.Sync.army
			and  uneSync.type  and  uneSync.type != nil  and  uneSync.type == typeBatiment
			and  uneSync.tech  and  uneSync.tech != nil  and  uneSync.tech == niveauTech  then
				return index  ---- POUR ACCÈS RAPIDE À ID UNITÉ DANS ListeSyncLabos
			end
		end

		return 0  ---- SIGNALER ZÉRO ÉLÉMENTS TROUVÉS
	end,


	AjouterUniteDansListeSyncLabos = function( self )

		local idArmee = self.Sync.army  ---- POUR TRAITER UNITÉ PAR ARMÉE

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AjouterUniteDansListeSyncLabos  :  UNITE ' .. tostring(self:GetUnitId()) .. '  ID ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  [' .. nomType[typeBatiment] .. '][TECH' .. tostring(niveauTech) ..  ']' )
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AjouterUniteDansListeSyncLabos  :  LISTE SYNC  AVANT = ' .. repr(ListeSyncLabos) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		local indexUnite = self:IndexUniteDansListeSyncLabos()

		---- FONCTION MAL UTILISÉE => VÉRIFIER LE SCRIPT !!!
		if  indexUnite == nil  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AjouterUniteDansListeSyncLabos  :  FONCTION IndexUniteDansListeSyncLabos MAL UTILISÉE => VÉRIFIER LE SCRIPT !!!' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

--[[
		------ CONTROLE DU SCRIPT EN COURS DE DEVELOPPEMENT ------  SUPPRIMER ENSUITE
		---- LISTE SYNC VIDE => AUCUN PROBLEME !!! ( CONTROLE DU SCRIPT EN COURS DE DEVELOPPEMENT )
		if  EstUnBooleen( indexUnite )  and  indexUnite == false  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AjouterUniteDansListeSyncLabos  :  LISTE SYNC VIDE => AUCUN PROBLEME !!!    ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		------ CONTROLE DU SCRIPT EN COURS DE DEVELOPPEMENT ------  SUPPRIMER ENSUITE
		---- ID NON RÉPERTORIÉ => AUCUN PROBLEME !!! ( CONTROLE DU SCRIPT EN COURS DE DEVELOPPEMENT )
		if  EstUnNombre( indexUnite )  and  indexUnite == 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AjouterUniteDansListeSyncLabos  :  ID UNITE NON REPERTORIE => AUCUN PROBLEME !!!    ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end
]]--

		---- ID UNITÉ TROUVÉ ! ( CAS IMPROBABLE ! )
		if  EstUnNombre( indexUnite )  and  indexUnite > 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			WARN( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AjouterUniteDansListeSyncLabos  :  ID UNITE TROUVE !!!    ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		local nouveauLabo = {
				army = self.Sync.army,
				id = self.Sync.id,
				bpid = self:GetUnitId(),
				type = typeBatiment,
				tech = niveauTech
		}

		---- INSÉRER DANS LISTE DES ID USINES
		table.insert( ListeSyncLabos, nouveauLabo ) ---- TRANSFERT ID LAB0

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AjouterUniteDansListeSyncLabos  :  ListeSyncLabos  APRES = ' .. repr(ListeSyncLabos) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		return true  ---- POUR GESTION ERREUR
	end,


	RetirerUniteDansListeSyncLabos = function( self )

		local idArmee = self.Sync.army  ---- POUR TRAITER UNITÉ PAR ARMÉE

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  RetirerUniteDansListeSyncLabos  :  UNITE ' .. tostring(self:GetUnitId()) .. '  id ' .. tostring(self.Sync.id) .. ' ARMEE ' .. tostring(self.Sync.army) .. '  [' .. nomType[typeBatiment] .. '][TECH' .. tostring(niveauTech) ..  ']' )
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  RetirerUniteDansListeSyncLabos  :  ListeSyncLabos  AVANT = ' .. repr(ListeSyncLabos) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		local indexUnite = self:IndexUniteDansListeSyncLabos()

		---- LISTE SYNC NON INITIALISÉE => REVOIR UTILISATION DE LA FONCTION IndexUniteDansListeSyncLabos !!!
		if  indexUnite == nil  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  RetirerUniteDansListeSyncLabos  :  LISTE SYNC NON INITIALISEE => REVOIR UTILISATION DE LA FONCTION IndexUniteDansListeSyncLabos    ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		---- LISTE SYNC VIDE => RIEN À RETIRER DE LA LISTE !!!
		if  EstUnBooleen( indexUnite )  and  indexUnite == false  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  RetirerUniteDansListeSyncLabos  :  LISTE SYNC VIDE => RIEN A RETIRER DE LA LISTE !!!    EstUnBooleen( indexUnite ) = ' .. tostring(EstUnBooleen(indexUnite)) .. ' (type = ' .. type(EstUnBooleen(indexUnite)).. ')  --  ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		---- ID UNITÉ NON RÉPERTORIÉ => RIEN À RETIRER DE LA LISTE !!!
		if  EstUnNombre( indexUnite )  and  indexUnite == 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  RetirerUniteDansListeSyncLabos  :  ID UNITE NON REPERTORIE => RIEN A RETIRER DE LA LISTE !!!    EstUnBooleen( indexUnite ) = ' .. tostring(EstUnBooleen(indexUnite)) .. ' (type = ' .. type(EstUnBooleen(indexUnite)).. ')  --  ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end

		---- ID UNITÉ TROUVÉ => RETIRER ID UNITÉ DE LA LISTE !
		if  EstUnNombre( indexUnite )  and  indexUnite > 0  then
			table.remove( ListeSyncLabos, indexUnite )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  RetirerUniteDansListeSyncLabos  :   ID UNITÉ REPERTORIE !!!  ListeSyncLabos  APRES  = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		end

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  RetirerUniteDansListeSyncLabos  :   VERIF  ListeSyncLabos  APRES  = ' .. repr(ListeSyncLabos) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		return true  ---- POUR GESTION ERREUR
	end,


	RecupUniteDejaConstruite = function( self )
		---- LISTE SYNC VIDE => PAS DE PROBLÈME CAR LABO PAS DÉJÀ CONSTRUIT !!!
		if  table.getsize( ListeSyncLabos ) <= 0  then  return false  end

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		---- TROUVER LABO DE MÊME ARMÉE ET DE MÊME TYPE
		for index, uneSync in ipairs( ListeSyncLabos ) do
			if   uneSync.id    and  uneSync.id != nil
			and  uneSync.army  and  uneSync.army != nil  and  uneSync.army == self.Sync.army
			and  uneSync.type  and  uneSync.type != nil  and  uneSync.type == typeBatiment  then
				return uneSync
			end
		end

		return false
	end,


	IdUniteDejaConstruite = function( self )
		local uniteDejaConstruite = self:RecupUniteDejaConstruite()
		if  uniteDejaConstruite == false  then  return false  end  ---- POUR GESTION ERREUR
		if  not uniteDejaConstruite.id  or  uniteDejaConstruite == nil  then  return false  end  ---- POUR GESTION ERREUR
		return uniteDejaConstruite.id
	end,


	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- FONCTIONS SPÉCIFIQUES AUX RECHERCHES :
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	InfosDeLaRecherche = function( self )

		local infosDeRecherche = false

		---- DÉTERMINER SI DEMANDEUR EST LABO / RECHERCHE  (OU BIEN USINE, ETC)
		if EntityCategoryContains( catLabo, self ) then
			local bp = self:GetBlueprint() or false
			if  bp == false  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
			if  bp.CetteRecherche == nil  or  bp.CetteRecherche == false  or  table.getsize( bp.CetteRecherche ) <= 0  then  return false  end  ---- POUR CONTROLE ULTÉRIEUR
			infosDeRecherche = {
				nomDeRecherche = bp.CetteRecherche.nomDeRecherche,
				niveauDeRecherche = bp.CetteRecherche.niveauDeRecherche,
			}
		end

		if  not infosDeRecherche  or  infosDeRecherche == nil  or  table.getsize( infosDeRecherche ) <= 0  then
			WARN( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  InfosDeLaRechercheDansLabo  :  ERREUR: infosDeRecherche (' .. type( infosDeRecherche ) .. '), DEVRAIT UNE TABLE NON VIDE !\n' )
			infosDeRecherche = false
		end

		return infosDeRecherche
	end,


	NomDeLaRecherche = function( self )

		local infosDeRecherche = self:InfosDeLaRecherche()
		local nomDeRecherche = false

		if  infosDeRecherche  then
			nomDeRecherche = infosDeRecherche.nomDeRecherche
		end

		return nomDeRecherche
	end,


	NiveauDeLaRecherche = function( self )

		local infosDeRecherche = self:InfosDeLaRecherche()
		local niveauDeRecherche = false

		if  infosDeRecherche  then
			niveauDeRecherche = infosDeRecherche.niveauDeRecherche
		end

		return niveauDeRecherche
	end,


	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    OnStartResearch = function( self, uniteArech, initiateur )
    end,


    OnStopResearch = function( self, uniteArech, initiateur )
    end,


--[[
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- NOTE DE MANIMAL :
	---- RECHERCHE INEXISTANTE CAR BATIMENT NOUVELLEMENT CONSTRUIT OU AMÉLIORÉ
	---- => MISE À JOUR OU CRÉATION DES INFOS DE LA RECHERCHE EFFECTUÉE !!!
	---- NIVEAU TECH DE RECHERCHE FAITE PERMET DE POINTER UN NIVEAU TECH DE USINE
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

	ActualiserNiveauRechercheLabo = function( self, constructeur )
		if  not constructeur  or  constructeur == nil  then  return false  end
		if  self.Sync.army != constructeur.Sync.army  then  return false  end  ---- CETTE ARMÉE UNIQUEMENT !

		---- M À J DE NiveauxRecherches  ( CONTIENT UN NIV RECHERCHE PAR NIV TECH )
		if  EstUnLabo( constructeur )  then
			self.NiveauxRecherches = constructeur.NiveauxRecherches
		end

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		self.NiveauxRecherches[niveauTech] = self:NiveauDeLaRecherche()
	end,


--[[
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- NOTE DE MANIMAL :
	---- LE NIVEAU DE RECHERCHE LABO DOIT AVOIR ÉTÉ PRÉALABLEMENT ACTUALISÉ
	---- FORCER KILLS SUR ZÉRO ALORS QUE KILLS EST DÉJÀ ÉGAL À ZÉRO => PLANTAGE DU JEU !!!
	---- R.À.Z DU NBR DE KILLS À CAUSE DU CUMUL DES KILLS VIA LES NIVEAUX VÉTERAN PRÉCÉDENTS
	---- VIA UPGRADE SINON FAUSSE COMPLÈTEMENT LE NIVEAU VÉTERAN ET REND LE JEU INSTABLE !!!
	---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

	FixerNouveauNiveauVeteranLabo = function( self )

		local niveauTechLabo = IndexTechUnite( self )
		if  niveauTechLabo == false  then  return false  end

		local niveauVeteran = self.NiveauxRecherches[niveauTechLabo]

		if  niveauVeteran  and  niveauVeteran > 0  then
			local numKills = self:GetStat( 'KILLS', 0 ).Value
			if  numKills > 0 then
				self:SetStat( 'KILLS', 0 )
			end
			self:SetVeterancy( niveauVeteran ) ---- MODIFIE LE NOMBRE DE KILLS !!! => JAMAIS MONTRÉ POUR USINES !
		end

	end,


--[[
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- NOTE DE MANIMAL :
	---- MISE À JOUR DIRECTE DES NIVEAUX VÉTÉRAN TOUTES USINES  VIA LISTES SYNC
	---- LE NIVEAU DE RECHERCHE LABO DOIT AVOIR ÉTÉ PRÉALABLEMENT ACTUALISÉ
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--
	--[[
		ListeSyncExemple =  {
			{
				army = number,
				id = string,
				type = number,
				tech = number
			},
		}
	]]--

	AppliquerRechercheSurUsines = function( self )

		local idArmee = self.Sync.army  ---- NE TRAITER QUE LES USINES DE LA MÊME ARMÉE

		local typeBatiment = IndexTypeUnite( self )
		if  typeBatiment == false  then  return false  end  ---- POUR GESTION ERREUR

		local niveauTech = IndexTechUnite( self )
		if  niveauTech == false  then  return false  end  ---- POUR GESTION ERREUR

		---- LISTE SYNC VIDE => AUCUNE ACTION POSSIBLE !!!
		if  table.getsize( ListeSyncUsines ) <= 0  then
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AppliquerRechercheSurUsines  :  LISTE SYNC VIDE => FIN DE FONCTION  POUR ARMÉE ' .. tostring(idArmee) .. '  TYPE  ' .. tostring(typeBatiment) .. '  TECH' .. tostring(niveauTech) .. ' !!!  ListeSyncUsines = ' .. repr(ListeSyncUsines) .. ' ' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			return false
		end  ---- POUR GESTION ERREUR

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AppliquerRechercheSurUsines  :  ListeSyncUsines  ARMEE ' .. tostring(idArmee) .. '  ' .. nomType[typeBatiment] .. '  TECH ' .. tostring(niveauTech) .. '  = ' .. repr(ListeSyncUsines) .. ' (type = ' .. type(ListeSyncUsines) .. ')' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		---- SCAN TOUTES USINES !!! ( PAS DE break ! )
		for index, uneSync in ipairs( ListeSyncUsines ) do
			----~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			--LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AppliquerRechercheSurUsines  :  ARMEE ' .. tostring(idArmee) .. '  uneSync = ' .. repr(uneSync) .. '  uneSync.id ' .. tostring(uneSync.id) .. '  uneSync.army ' .. tostring(uneSync.army) .. '  uneSync.type = ' .. tostring(uneSync.type) .. ' = ' .. nomType[uneSync.type] .. '  uneSync.tech ' .. tostring(uneSync.tech) )
			----~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			if   uneSync.id    and  uneSync.id != nil
			and  uneSync.army  and  uneSync.army != nil  and  uneSync.army == self.Sync.army
			and  uneSync.type  and  uneSync.type != nil  and  uneSync.type == typeBatiment  then
			--and  uneSync.tech  and  uneSync.tech != nil  and  uneSync.tech == niveauTech  then

				local uneUsine = GetUnitById( uneSync.id )

				if  uneUsine  and  uneUsine != nil  and  not uneUsine:IsDead()  then

					local niveauDeRecherche = self.NiveauxRecherches[niveauTech] ---- NIVEAU VÉTÉRAN DU LABO

					if  niveauDeRecherche  and  niveauDeRecherche > 0  then
						uneUsine.NiveauxVeteran = self.NiveauxRecherches

						--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
						LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AppliquerRechercheSurUsines  :  niveauDeRecherche = ' .. tostring(niveauDeRecherche) .. '  SUR  uneUsine ' .. tostring(uneUsine:GetUnitId()) .. '  ID ' .. tostring(uneUsine.Sync.id) .. '  ARMEE ' .. tostring(idArmee) .. '  [' .. nomType[typeBatiment] .. '][TECH' .. tostring(niveauTech) ..  '] --' )
						LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  AppliquerRechercheSurUsines  :  uneUsine.NiveauxVeteran = ' .. repr( uneUsine.NiveauxVeteran ) )
						--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

						local nivTechUsine = IndexTechUnite( uneUsine )
						if  nivTechUsine == false  then  return false  end  ---- POUR GESTION ERREUR
						local nivRecherche = self.NiveauxRecherches[nivTechUsine] ---- NIVEAU VÉTÉRAN DU LABO

						local numKills = uneUsine:GetStat( 'KILLS', 0 ).Value
						if  numKills > 0 then
							uneUsine:SetStat( 'KILLS', 0 )
						end

						uneUsine:SetVeterancy( nivRecherche ) ---- MODIFIE LE NOMBRE DE KILLS !!! => JAMAIS MONTRÉ POUR USINES !
					end
				end  ---- END IF uneUsine

			end  ---- END IF uneSyncId
		end  ---- END FOR

		return true  ---- POUR GESTION ERREUR

	end,  ---- END AppliquerRechercheSurUsines


	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	---- OnResearchCompleted = function( self, uniteArech, initiateur )
	---- 	uniteArech  : Labo En Cours de Construction
	---- 	initiateur : Labo Initiateur Upgrade (le constructeur)
	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    OnResearchCompleted = function( self, uniteArech, initiateur )

		if  not initiateur  or  initiateur == nil  then  return false  end
		if  not uniteArech  or  uniteArech == nil  then  return false  end

		self:ActualiserNiveauRechercheLabo( initiateur )

		self:FixerNouveauNiveauVeteranLabo() ---- MODIFIE LE NOMBRE DE KILLS !!!

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local selfUnId = self:GetUnitId()
		local recUid = uniteArech:GetUnitId()
		local iniUid = initiateur:GetUnitId()
		--local nomRecherche = self.NomDeLaRecherche( uniteArech )
		local nomRecherche = uniteArech:NomDeLaRecherche()
		local niveauRecherche = self.NiveauxRecherches[ IndexTechUnite( uniteArech ) ]
		if  niveauRecherche == false  then  return false  end
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnResearchCompleted  :  Labo  ' .. tostring(selfUnId) .. '  >  RECHERCHE EN COURS [' .. nomRecherche .. ']  DE NIVEAU [' .. tostring(niveauRecherche) .. ']  PAR  [' .. tostring(iniUid) .. ']  >  REUSSIE ! ' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		self:AppliquerRechercheSurUsines()

   end,


	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- FIN DES FONCTIONS SPÉCIFIQUES AUX RECHERCHES :
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    OnStartBeingBuilt = function( self, builder, layer )

		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		local idUniteBuilder = builder:GetUnitId() or "UNITE INCONNUE"

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :  CONSTRUCTION DE LABO '.. tostring(idUnite) .. '  PAR  ' .. tostring(idUniteBuilder) .. '  SUR  ' .. tostring(layer) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		---- NOTIFICATION DU CONSTRUCTEUR ( UBC )
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if  builder  and  builder != nil  and  not builder:IsDead()  then

			local idArmee = self.Sync.army  ---- POUR TRAITER UNITÉ PAR ARMÉE

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :  PREMIER LABO VERIF  LaboReInit = ' .. repr(LaboReInit) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			---- 1 ÈRE CONSTRUCTION / RECONSTRUCTION
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if  EntityCategoryContains( catCmndr, builder )  then

				---- MÉMORISATION ( UBC ) DU LABO POUR RESTRICTIONS
				---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if  not builder.catBatimentsDejaContruits  or  builder.catBatimentsDejaContruits == nil  then
					builder.catBatimentsDejaContruits = {}
				end
				local typeBatiment = IndexTypeUnite( self )
				local niveauTech = IndexTechUnite( self )
				---- NIVEAU TECH CAR BLOCAGE PARTIEL
				local CatConstruite = 'LABO ' .. nomType[typeBatiment] .. ' ' .. nomTech[niveauTech]
				table.insert( builder.catBatimentsDejaContruits, CatConstruite )

				---- RETROUVER LE LABO À RECONSTRUIRE. SUPPOSE QUE LaboReInit À ÉTÉ INITIALISÉ CORRECTEMENT
				---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				local laboBpid = false

				for index, unLabo in ipairs( LaboReInit ) do
					if unLabo != nil  and  unLabo.army == idArmee  and  unLabo.bpid == idUnite  then
						laboBpid = unLabo.bpid
						break
					end
				end

				if  laboBpid == false  then  ---- PREMIÈRE CONSTRUCTION PAR UBC DE TOUS NIVEAUX
					---- NOTIFIER UBC DE RESTRICTION DU LABO DEJA CONSTRUIT
					---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					self:RestreindreConstructionDeLaboVeteran( self, builder )

					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :  EST PREMIERE CONSTRUCTION  laboBpid ' .. tostring(laboBpid) .. '  ARMEE ' .. tostring(idArmee) .. '  LaboReInit = ' .. repr(LaboReInit) )
					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

				elseif  laboBpid != false  and  laboBpid != nil  then  ---- RECONSTRUCTION
					---- NOTIFIER UBC DE RESTRICTION DU LABO RECONSTRUIT, PAS DU MEME NIVEAU TECH
					---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					local catBpIdLaboReconstruit = CategorieIdUnite( laboBpid )
					RestreindreConstructionParCategorie( builder, catBpIdLaboReconstruit ) ---- ASSURER LA RESTRICTION

					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :  EST RECONSTRUCTION DE  ' .. tostring(laboBpid) .. '  ARMEE ' .. tostring(idArmee) .. '  LaboReInit = ' .. repr(LaboReInit) )
					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				end

				self.idPerePremierLabo = builder.Sync.id  ---- INDISPENSABLE POUR OnDestroy

				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :  TRANSFERT ID LABO  ' .. idUnite .. ' <type = ' .. type(idUnite) .. '>  ( PREMIERE CONSTRUCTION / RECONSTRUCTION ) !  builder.catBatimentsDejaContruits = ' .. repr(builder.catBatimentsDejaContruits) )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			---- UPGRADE
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			elseif  EntityCategoryContains( catLabo, builder )  then

				---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				---- NOTE DE MANIMAL :
				---- NOUVELLE RESTRICTION IMPOSÉE PAR ASDRUBAEL
				---- ENPÊCHER UBC DE CONSTRUIRE LABO DE NIV TECH ACTUEL
				---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				if  self:PasseAuNiveauTechSuivant( self, builder ) == true  then
					local zeUBC = false
					if  builder.idPerePremierLabo  and  builder.idPerePremierLabo != nil  then
						zeUBC = GetUnitById( builder.idPerePremierLabo )
					end
					if  zeUBC  and  zeUBC != nil  and  not zeUBC:IsDead()  then
						---- MÉMORISATION ( UBC ) DU LABO POUR RESTRICTIONS
						---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
						if  not zeUBC.catBatimentsDejaContruits  or  zeUBC.catBatimentsDejaContruits == nil  then
							zeUBC.catBatimentsDejaContruits = {}
						end
						local typeBatiment = IndexTypeUnite( self )
						local niveauTech = IndexTechUnite( self )
						---- NIVEAU TECH CAR BLOCAGE PARTIEL
						local CatConstruite = 'LABO ' .. nomType[typeBatiment] .. ' ' .. nomTech[niveauTech]
						table.insert( zeUBC.catBatimentsDejaContruits, CatConstruite )

						self:RestreindreConstructionDeLaboVeteran( self, zeUBC )

						--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
						LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :  ID LABO UPGRADE = ' .. idUnite .. ' <type = ' .. type(idUnite) .. '>  zeUBC.catBatimentsDejaContruits = ' .. repr(zeUBC.catBatimentsDejaContruits) )
						--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					end
				end

				self.idPerePremierLabo = builder.idPerePremierLabo  ---- INDISPENSABLE POUR OnDestroy

				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :  TRANSFERT ID LABO ( UPGRADE ) !' )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			end  ---- END IF  EntityCategoryContains

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBeingBuilt  :   Pere du Labo = ' .. tostring(self.idPerePremierLabo) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		end  ---- END IF  builder

		StructureUnit.OnStartBeingBuilt( self, builder, layer )
    end,


    OnStopBeingBuilt = function( self, builder, layer )

        local aiBrain = GetArmyBrain( self:GetArmy() )
        aiBrain:ESRegisterUnitMassStorage( self )
        aiBrain:ESRegisterUnitEnergyStorage( self )
        local curEnergy = aiBrain:GetEconomyStoredRatio( 'ENERGY' )
        local curMass = aiBrain:GetEconomyStoredRatio( 'MASS' )
        if curEnergy > 0.11 and curMass > 0.11 then
            self:CreateBlinkingLights( 'Green' )
            self.BlinkingLightsState = 'Green'
        else
            self:CreateBlinkingLights( 'Red' )
            self.BlinkingLightsState = 'Red'
        end
        StructureUnit.OnStopBeingBuilt( self, builder, layer )

		----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        self:SetMaintenanceConsumptionActive()

		local idUnite = self:GetUnitId() or "UNITE INCONNUE (LABO ?)"
		local idUniteBuilder = builder:GetUnitId() or "UNITE INCONNUE (LABO ?)"

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStopBeingBuilt  :  CONSTRUCTION DE LABO '.. tostring(idUnite) .. '  PAR  ' .. tostring(idUniteBuilder) .. '  SUR  ' .. tostring(layer) )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		---- ~~~~~~~~~~~~~~~~~~~~~~~~
		---- (RE)CONSTRUCTION ACHEVÉE
		---- ~~~~~~~~~~~~~~~~~~~~~~~~
		local fractionComplete = self:GetFractionComplete()

		if  fractionComplete == 1  then  ---- ASSURANCE QUE UPGRADE / RECONSTRUCTION EST TERMINÉ

			local idArmee = self.Sync.army  ---- NE TRAITER QUE LES LABOS DE LA MÊME ARMÉE

			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			---- RéINIT DES RECONSTRUCTIONS
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if  EntityCategoryContains( catCmndr, builder )  then

				local indexLabo = false
				---- RETROUVER LE LABO RECONSTRUIT. SUPPOSE QUE LaboReInit À ÉTÉ INITIALISÉ CORRECTEMENT
				for index, unLabo in ipairs( LaboReInit ) do
					if  unLabo != nil  and  unLabo.army == idArmee  and  unLabo.bpid == idUnite  then
						indexLabo = index
						break
					end
				end
				if  indexLabo  and  indexLabo > 0  then
					---- RESTAURER LES RECHERCHES DU LABO RECONSTRUIT.
					self.NiveauxRecherches = LaboReInit[indexLabo].rech
					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStopBeingBuilt  :  LABO  RECONSTRUIT ID = ' .. tostring(self.Sync.id) .. ' ARMY ' .. tostring(idArmee) .. '  INDEX = ' .. tostring(indexLabo) .. '  LaboReInit AVANT MODIF = ' .. repr(LaboReInit) )
					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					---- SUPPRIMER LE LABO RECONSTRUIT.
					table.remove( LaboReInit, indexLabo ) ---- R à Z
				end

				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStopBeingBuilt  :  VERIF  LABO ID = ' .. tostring(self.Sync.id) .. ' ARMY ' .. tostring(idArmee) .. '  LaboReInit = ' .. repr(LaboReInit) )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			end  ---- END  IF  EntityCategoryContains

			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			---- ENREGISTREMENT DE LA RECHERCHE
			----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStopBeingBuilt  :  CONTROLE AVANT MODIF  ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			self:AjouterUniteDansListeSyncLabos()  ---- TRANSFERT ID LAB0

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStopBeingBuilt  :  CONTROLE APRES MODIF  ListeSyncLabos = ' .. repr(ListeSyncLabos) )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			self:OnResearchCompleted( self, builder )  ---- SIGNALER RECHERCHE TERMINEE !

			end  ---- END IF fractionComplete

	----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end,


    OnStartBuild = function( self, unitBeingBuilt, order )

		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		---- LES LABOS NE CONSTRUISENT RIEN !!!
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if order != 'Upgrade' then  return  end
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		self.Upgrading = false

		---- REPRISE PARTIELLE DU CODE DE Unit.OnStartBuild
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        self:DoOnStartBuildCallbacks( unitBeingBuilt )
        self:SetActiveConsumptionActive()

        self.UnitBeingBuilt = unitBeingBuilt

		local bp = self:GetBlueprint() or false
		if  not bp  or  not bp.General.UpgradesTo  then  return false  end
		local upgradesToUnitId = bp.General.UpgradesTo
		local unitBeingBuiltId = unitBeingBuilt:GetUnitId()

		if  unitBeingBuiltId == upgradesToUnitId  and  order == 'Upgrade'  then
			self.Upgrading = true
			unitBeingBuilt.DisallowCollisions = true

			if unitBeingBuilt:GetBlueprint().Physics.FlattenSkirt and not unitBeingBuilt:HasTarmac() then
				if self.TarmacBag and self:HasTarmac() then
					unitBeingBuilt:CreateTarmac(true, true, true, self.TarmacBag.Orientation, self.TarmacBag.CurrentBP )
				else
					unitBeingBuilt:CreateTarmac(true, true, true, false, false)
				end
			end

			self:ChangeBlinkingLights( 'Yellow' )  -- AJOUTER AU LABO des VOYANTS CLIGNOTANTS  OU un BuildEffect ?

			ChangeState( self, self.UpgradingState )

			---- TRAITER LES RECHERCHES DU LABO
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if  EstUneRecherche( unitBeingBuilt ) == true  then
				self:OnStartResearch( unitBeingBuilt, self )  -- SIGNALER RECHERCHE COMMENCÉE !
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStartBuild  :  LABO ACTION = RECHERCHE LANCEE !\n' )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end
		end
    end,


--[[
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- REMARQUE DE MANIMAL : OnStopBuild
	-- SHUNTÉ PAR UpgradingState.OnStopBuild !
	-- ACTIF SI UpgradingState.OnFailedToBuild
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--
--[[
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- BUG FIX BY MANIMAL :
	-- I NOTICED THAT MANY CLASSES DO NOT DEFIME OnStopBuild THE SAME WAY FOR MOST OF THE FACTORIES
	-- WHEN OnStopBuild IS FIRED FROM AIR AND/OR NAVAL FACOTRY UNITS, THE VALUE OF order IS nil !!!
	-- THE PROBLEM SITS WITHIN xxxxunits.lua (xxxx = FACTION NAME) THAT DEFINES UNCONSISTENTLY OnStopBuild
	-- FOR AIR + SEA + SUB FactoryUnit CLASSES, THAT DOES NOT MATCH AT ALL THE DEFINITION OF GENERIC FactoryUnit within defaultunits.lua !!!
	-- J'AI REMARQUÉ QUE PLUSIEURS CLASSES DÉFINISSENT OnStopBuild DIFFÉREMMENT POUR LA PLUPART DES USINES
	-- PENDANT LA CONSTRUCTION D'UNITÉS AIR ET/OU NAVAL, LA VALEUR DE order ESR nil !!!
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--


    OnStopBuild = function( self, unitBeingBuilt, order )

        ---- LES LABOS NE CONSTRUISENT RIEN !!!
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if order != 'Upgrade' then  return  end

		---- REPRISE PARTIELLE DU CODE DE Unit.OnStopBuild
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        self:SetActiveConsumptionInactive()
        self:DoOnUnitBuiltCallbacks(unitBeingBuilt)

		---- TRAITER LES AMÉLIORATIONS DU LABO -- SHUNTÉ PAR UpgradingState.OnStopBuild !
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local bp = self:GetBlueprint() or false
		if  bp == false then  return false  end
		local unitid = bp.General.UpgradesTo

		local selfUnId = self:GetUnitId()
		local ubbId = self.UnitBeingBuilt:GetUnitId()

		if  order  and  order == 'Upgrade'  then -- SHUNTÉ PAR UpgradingState.OnStopBuild !
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStopBuild  :  AMELIORATION  DE ' .. tostring(selfUnId) .. ' EN ' .. tostring(ubbId) .. ' TERMINEE !' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			---- TRAITER LES RECHERCHES DU LABO
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			if  EstUneRecherche( unitBeingBuilt ) == true  then  ---- LE LABO TERMINE LA RECHERCHE !!!
				self:OnStopResearch( unitBeingBuilt, self )  ---- SIGNALER RECHERCHE INTERROMPUE !

				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnStopBuild  :  LABO ACTION = RECHERCHE TERMINÉE !\n' )
				--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			end
		end

		self.Upgrading = false
    end,


	---- EN CAS D'UPGRADE INTERROMPU
    OnFailedToBuild = function( self )
        --self.LaboratoryBuildFailed = true  ---- self.FactoryBuildFailed = true  NE S'APPLIQUE PAS AUX LABOS
        --Unit.OnFailedToBuild( self )    ---- StructureUnit.OnFailedToBuild( self )  NE S'APPLIQUE PAS AUX LABOS
        self:DestroyBuildRotator()
        self:StopBuildFx()
        ChangeState( self, self.IdleState )
    end,


    CheckBuildRestriction = function( self, target_bp )

        if self:CanBuild( target_bp.BlueprintId ) then
            return true
        else
            return false
        end
    end,


    OnReclaimed = function( self, entity )

		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local idUnite = self:GetUnitId() or "UNITE INCONNUE"
		local idEntity = entity:GetUnitId() or "UNITE INCONNUE"
		LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnReclaimed  : UNITE RECYCLEE ' .. tostring(idUnite) .. '  PAR  ' .. tostring(idEntity) .. '\n' )
		--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        if  self.UnitBeingBuilt  and  not self.UnitBeingBuilt:IsDead()
        and  self.UnitBeingBuilt:GetFractionComplete() != 1  then

			---- POUR GARANTIR QUE UBC NE VERRA PAS UnitBeingBuilt COMME UNITÉ À RECONSTRUIRE :
			---- SI BESOIN ACTIVER self.UnitBeingBuilt.idPerePremierLabo = false

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local ubbId = self.UnitBeingBuilt:GetUnitId()
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnReclaimed  :  RECYCLAGE DU LABO ' .. tostring(idUnite) .. ' AVEC SA RECHERCHE EN COURS ' .. tostring(ubbId) .. ' !!!\n' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        end

		self.LaboReclaimed = true

        StructureUnit.OnReclaimed( self, entity )
    end,


    OnKilled = function( self, instigator, type, overkillRatio )

        if  self.UnitBeingBuilt  and  self.UnitBeingBuilt != nil  and  not self.UnitBeingBuilt:IsDead()
        and  self.UnitBeingBuilt:GetFractionComplete() != 1  then
			---- POUR GARANTIR QUE UBC NE VERRA PAS UnitBeingBuilt COMME UNITÉ À RECONSTRUIRE :
			---- SI BESOIN ACTIVER self.UnitBeingBuilt.idPerePremierLabo = false

			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local uniteId = self:GetUnitId()
			local ubbId = self.UnitBeingBuilt:GetUnitId()
			local tueurId = "UNITE NON IDENTIFIEE ( OU CTRL-K ) !!!"
			if  instigator  and  instigator != nil  then
				tueurId = instigator:GetUnitId()
			end
			LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnKilled  :  LABO ' .. tostring(uniteId) .. '  TUE PAR  ' .. tostring(tueurId) .. '  AVEC SA RECHERCHE EN COURS ' .. tostring(ubbId) .. ' !!!\n' )
			--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        end

		self.LaboKilled = true

        StructureUnit.OnKilled( self, instigator, type, overkillRatio )
    end,


--[[
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- NOTE DE MANIMAL : AUCUN OnDestroy DANS DefaultUnits.StructureUnit ORIGINAL !
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

    OnDestroy = function( self )  --NE FONCTIONNE PAS ICI :  self:IsUnitState( 'Upgrading' )

		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		---- NOTE DE MANIMAL :
		---- LE LABO DOIT DEVENIR RECONSTRUCTIBLE ! ( MAIS PAS SON UPGRADE INACHEVÉ )
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		if  self.LaboKilled == true  or  self.LaboReclaimed == true  then

			---- NOTIFICATION DU CONSTRUCTEUR ( UBC )
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local zeUBC = false

			if  self.idPerePremierLabo  and  self.idPerePremierLabo != nil  then
				zeUBC = GetUnitById( self.idPerePremierLabo )
			end

			---- AUTORISER LA RECONSTRUCTION DU LABO MORT !
			---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			local idArmee = self.Sync.army  ---- NE TRAITER QUE LES USINES DE LA MÊME ARMÉE

			local indexTypeUnite = IndexTypeUnite( self )  ---- INDISPENSABLE POUR RECONSTRUIRE
			local uniteId = self:GetUnitId()

			if  indexTypeUnite  and  indexTypeUnite > 0  then
				if  zeUBC != false  and  zeUBC != nil  and  not zeUBC:IsDead()  and  idArmee == zeUBC.Sync.army  then

					---- M À J DE catBatimentsDejaContruits PAR RETRAIT DE CatDetruite
					---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					if  zeUBC.catBatimentsDejaContruits  and  zeUBC.catBatimentsDejaContruits != nil
					and  table.getsize( zeUBC.catBatimentsDejaContruits ) > 0  then
						local typeBatiment = IndexTypeUnite( self )
						--local niveauTech = IndexTechUnite( self )
						--local CatDetruite = 'LABO ' .. nomType[typeBatiment] .. ' ' .. nomTech[niveauTech]
						---- PAS DE NIVEAU TECH CAR BLOCAGE TOTAL
						local CatDetruite = 'LABO ' .. nomType[typeBatiment]
						for i, uneCat in ipairs( zeUBC.catBatimentsDejaContruits ) do
							if  uneCat == CatDetruite  then
								table.remove( zeUBC.catBatimentsDejaContruits, i )
								break
							end
						end
					end

					local catLaboDetruit = CategorieIdUnite( uniteId )  -- DÉBLOQUER LE LABO DÉTRUIT UNIQUEMENT
					PermettreConstructionParCategorie( zeUBC, catLaboDetruit )

					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnDestroy  :  VERIF  AVANT  uniteId = ' .. tostring(uniteId) .. '  indexTypeUnite = ' .. nomType[indexTypeUnite] .. '  self.idPerePremierLabo = ' .. tostring(self.idPerePremierLabo) .. '  zeUBC.LaboReInit = ' .. repr(zeUBC.LaboReInit) )
					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

					local infoLabo = {  ---- INDISPENSABLE POUR RECONSTRUIRE
						army = self.Sync.army,
						bpid = uniteId,
						rech = self.NiveauxRecherches
					}

					---- ENREGISTRER LE LABO À RECONSTRUIRE. SUPPOSE QUE LaboReInit À ÉTÉ INITIALISÉ CORRECTEMENT
					table.insert( LaboReInit, infoLabo )

					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					LOG( 'MANIMAL TRACEUR  /lua/EW_DefaultUnits.lua  LSU  ->  OnDestroy  :  VERIF  APRES  uniteId = ' .. tostring(uniteId) .. '  indexTypeUnite = ' .. nomType[indexTypeUnite] .. '  self.idPerePremierLabo = ' .. tostring(self.idPerePremierLabo) .. '  zeUBC.LaboReInit = ' .. repr(zeUBC.LaboReInit) )
					--~~~~~ TRACEURS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

				end  ----  END IF  zeUBC
			end  ----  END IF  indexTypeUnite
		end  ---- END IF  self.LaboKilled  OR  self.LaboReclaimed

		---- METTRE À JOUR LA LISTE DES RECHERCHES DU LABO !
		---- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		self:RetirerUniteDansListeSyncLabos()

		if  self.ResearchEffectsBag  then
			self.ResearchEffectsBag:Destroy()
		end

        StructureUnit.OnDestroy( self )
    end,


--[[
    ------------------------------------------------------------------------------------------
    -- STATES
    ------------------------------------------------------------------------------------------
]]--

    IdleState = State {
        Main = function( self )
            self:ChangeBlinkingLights( 'Green' )
            self:SetBusy( false )
            self:SetBlockCommandQueue( false )
        end,
    },


--[[
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- NOTE DE MANIMAL :
	-- SURCHARGE INDISPENDABLE DE StructureUnit.UpgradingState ORIGINAL !
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

    UpgradingState = State {

        Main = function( self )
            self:StopRocking()
            local bp = self:GetBlueprint().Display
            self:DestroyTarmac()
            self:PlayUnitSound('UpgradeStart')
            self:DisableDefaultToggleCaps()
            if bp.AnimationUpgrade then
                local unitBuilding = self.UnitBeingBuilt
                self.AnimatorUpgradeManip = CreateAnimator( self )
                self.Trash:Add( self.AnimatorUpgradeManip )
                local fractionOfComplete = 0
                self:StartUpgradeEffects( unitBuilding )
                self.AnimatorUpgradeManip:PlayAnim( bp.AnimationUpgrade, false ):SetRate(0)

                while fractionOfComplete < 1 and not self:IsDead() do
                    fractionOfComplete = unitBuilding:GetFractionComplete()
                    self.AnimatorUpgradeManip:SetAnimationFraction( fractionOfComplete )
                    WaitTicks( 1 )
                end
                if not self:IsDead() then
                    self.AnimatorUpgradeManip:SetRate( 1 )
                end
            end
        end,

        OnStopBuild = function( self, unitBuilding )
			self:SetActiveConsumptionInactive()
			self:DoOnUnitBuiltCallbacks( unitBuilding )
            self:EnableDefaultToggleCaps()

            if unitBuilding:GetFractionComplete() == 1 then
                NotifyUpgrade( self, unitBuilding )
                self:StopUpgradeEffects( unitBuilding )
                self:PlayUnitSound('UpgradeEnd')
                self:Destroy()
            end
        end,

        OnFailedToBuild = function( self )
            Unit.OnFailedToBuild( self )    --StructureUnit.OnFailedToBuild( self )
            self:EnableDefaultToggleCaps()

            if self.AnimatorUpgradeManip then
				self.AnimatorUpgradeManip:Destroy()
			end

            if self:GetCurrentLayer() == 'Water' then
                self:StartRocking()
            end
            self:PlayUnitSound('UpgradeFailed')
            self:PlayActiveAnimation()
            self:CreateTarmac( true, true, true, self.TarmacBag.Orientation, self.TarmacBag.CurrentBP )
            ChangeState( self, self.IdleState )
        end,

    },


}



---------------------------------------------------------------
--  LAND RESEARCH LAB UNIT
---------------------------------------------------------------

LandResearchLabUnit = Class( LaboStructureUnit ) {}


---------------------------------------------------------------
--  AIR RESEARCH LAB UNIT
---------------------------------------------------------------

AirResearchLabUnit = Class( LaboStructureUnit ) {}


---------------------------------------------------------------
--  NAVAL UNIT RESEARCH LAB
---------------------------------------------------------------

NavalResearchLabUnit = Class( LaboStructureUnit ) {}




------------------------  FIN DE  EW_DefaultUnits.lua  ------------------------
