g_EaseCfg={
	{
		name="LinearEase",
		new=function()
			return LinearEase:create()
		end,

		edit=false,
	},
	{
		name="QuadEase",
		new=function()
			return QuadEase:create()
		end,
		edit=false,
	},
	{
		name="CubicEase",
		new=function()
			return CubicEase:create()
		end,
		edit=false,
	},
	{
		name="QuartEase",
		new=function()
			return QuartEase:create()
		end,
		edit=false,
	},
	{
		name="QuintEase",
		new=function()
			return QuintEase:create()
		end,
		edit=false,
	},
	{
		name="PowerEase",
		new=function()
			return PowerEase:create(2)
		end,
		edit=false,
	},
	{
		name="ExponentialEase",
		new=function()
			return ExponentialEase:create()
		end,
		edit=false,
	},
	{
		name="BackEase",
		new=function()
			return BackEase:create()
		end,
		edit=false,
	},
	{
		name="BounceEase",

		new=function()
			return BounceEase:create()
		end,

		edit=false,
	},
	{
		name="CircleEase",
		new=function() 
			return CircleEase:create()
		end,
		edit=false,
	},
	{
		name="ElasticEase",
		new=function()
			return ElasticEase:create()
		end,
		edit=false,
	},
	{
		name="BezierEase",
		new=function()
			--return BezierEase:create(Vector2(0.3,0.0),Vector2(0.6,1.0))
			return LinearEase:create()
		end,
		edit=false,
	},
	{
		name="SineEase",
		new=function()
			return SineEase:create()
		end,
		edit=false,
	}
}
