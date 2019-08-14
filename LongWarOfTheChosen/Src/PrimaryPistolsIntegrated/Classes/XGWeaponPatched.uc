class XGWeaponPatched extends XGWeapon;

simulated function Actor CreateEntity(optional XComGameState_Item ItemState=none)
{
	local XComWeapon Weapon, Template;

	Weapon = XComWeapon(super.CreateEntity(ItemState));

	if (Weapon != none)
	{
		Template = Weapon;
		Template.CustomUnitPawnAnimsets.Length = 0;
		Template.CustomUnitPawnAnimsets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("PrimaryPistolsMod.Anims.AS_Pistol")));
		Template.DefaultSocket = 'R_Hand';

		m_kEntity = Spawn(Template.Class, Template.Owner,,,,Template);
	}
	return m_kEntity;
}
