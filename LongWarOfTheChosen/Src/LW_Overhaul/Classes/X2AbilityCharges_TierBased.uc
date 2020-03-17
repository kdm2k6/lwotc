class X2AbilityCharges_TierBased extends X2AbilityCharges;

var int CV_Charges; 
var int LS_Charges; 
var int MG_Charges;
var int CG_Charges; 
var int BM_Charges;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local XComGameState_Item ItemState;
    local X2WeaponTemplate WeaponTemplate;
    local int Charges;

    Charges = InitialCharges;
    ItemState = Ability.GetSourceWeapon();
    if(ItemState != none)
    {
        WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
        if(WeaponTemplate != none)
        {
			switch (WeaponTemplate.WeaponTech)
			{
				case 'conventional': Charges = CV_Charges; break;
				case 'laser_lw': Charges = LS_Charges; break;
				case 'magnetic': Charges = MG_Charges; break;
				case 'coilgun_lw': Charges = CG_Charges; break;
				case 'beam': Charges = BM_Charges; break;
				Default: break;
			}
        }
    }
    return Charges;
}

defaultproperties
{
    InitialCharges=1
}