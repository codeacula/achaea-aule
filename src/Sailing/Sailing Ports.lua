AuleSailing = AuleSailing or {}
AuleSailing.ports = {
  {
    name = "Ageiro",
    fee = 0,
    trades = {
      { get = { amount = 1, what = "gems" }, pay = { amount = 2, what = "tabac" } },
      { get = { amount = 3, what = "silk" }, pay = { amount = 2, what = "tabac" } },
    },
    ignore = false,
  },
  {
    name = "Colchis",
    fee = 0,
    trades = {
      { get = { amount = 2, what = "silk" },    pay = { amount = 3, what = "marble" } },
      { get = { amount = 2, what = "perfume" }, pay = { amount = 3, what = "incense" } },
      { get = { amount = 3, what = "glass" },   pay = { amount = 2, what = "incense" } },
    },
    ignore = false,
  },
  {
    name = "Karbaz",
    fee = 200,
    trades = {
      { get = { amount = 2, what = "ceramics" }, pay = { amount = 3, what = "honey" } },
      { get = { amount = 2, what = "ceramics" }, pay = { amount = 3, what = "hemp" } },
      { get = { amount = 2, what = "marble" },   pay = { amount = 3, what = "hemp" } },
      { get = { amount = 2, what = "marble" },   pay = { amount = 3, what = "granite" } },
    },
    ignore = false,
  },
  {
    name = "Minos",
    fee = 0,
    trades = {
      { get = { amount = 3, what = "honey" }, pay = { amount = 4, what = "salt" } },
      { get = { amount = 2, what = "wine" },  pay = { amount = 3, what = "marble" } },
      { get = { amount = 2, what = "wine" },  pay = { amount = 3, what = "tea" } },
    },
    ignore = false,
  },
  {
    name = "Mysia",
    fee = 1000,
    trades = {
      { get = { amount = 2, what = "tabac" },    pay = { amount = 3, what = "porcelain" } },
      { get = { amount = 2, what = "tabac" },    pay = { amount = 3, what = "silk" } },
      { get = { amount = 3, what = "ceramics" }, pay = { amount = 2, what = "porcelain" } },
      { get = { amount = 3, what = "ceramics" }, pay = { amount = 2, what = "silk" } },
    },
    ignore = false,
  },
  {
    name = "Orilla",
    fee = 0,
    trades = {
      { get = { amount = 3, what = "terracotta" }, pay = { amount = 4, what = "cotton" } },
    },
    ignore = true,
  },
  {
    name = "Shala-Khulia",
    fee = 500,
    trades = {
      { get = { amount = 2, what = "incense" }, pay = { amount = 3, what = "glass" } },
    },
    ignore = false,
  },
  {
    name = "Shastaan",
    fee = 1000,
    trades = {
      { get = { amount = 1, what = "cotton" },    pay = { amount = 1000, what = "gp" } },
      { get = { amount = 3, what = "hemp" },      pay = { amount = 4, what = "furs" } },
      { get = { amount = 1, what = "gems" },      pay = { amount = 2, what = "perfume" } },
      { get = { amount = 3, what = "wine" },      pay = { amount = 2, what = "perfume" } },
      { get = { amount = 1, what = "sandstone" }, pay = { amount = 1000, what = "gp" } },
    },
    ignore = false,
  },
  {
    name = "Suliel (West)",
    fee = 500,
    trades = {
      { get = { amount = 1, what = "furs" },    pay = { amount = 1, what = "wool" } },
      { get = { amount = 2, what = "incense" }, pay = { amount = 3, what = "kahwe" } },
    },
    ignore = true,
  },
  {
    name = "Suliel (East)",
    fee = 0,
    trades = {
      { get = { amount = 1, what = "furs" },    pay = { amount = 1, what = "wool" } },
      { get = { amount = 2, what = "incense" }, pay = { amount = 3, what = "kahwe" } },
    },
    ignore = true,
  },
  {
    name = "Tasur'ke",
    fee = 2000,
    trades = {
      { get = { amount = 1, what = "wool" },    pay = { amount = 1000, what = "gp" } },
      { get = { amount = 3, what = "granite" }, pay = { amount = 4, what = "sandstone" } },
      { get = { amount = 2, what = "kahwe" },   pay = { amount = 3, what = "sugar" } },
    },
    ignore = false,
  },
  {
    name = "Thraasi",
    fee = 2000,
    trades = {
      { get = { amount = 1, what = "ore" },       pay = { amount = 1000, what = "gp" } },
      { get = { amount = 2, what = "glass" },     pay = { amount = 3, what = "fruits" } },
      { get = { amount = 2, what = "armaments" }, pay = { amount = 1, what = "spices" } },
      { get = { amount = 1, what = "grain" },     pay = { amount = 1000, what = "gp" } },
    },
    ignore = false,
  },
  {
    name = "Umbrin",
    fee = 0,
    trades = {
      { get = { amount = 2, what = "porcelain" }, pay = { amount = 3, what = "ceramics" } },
      { get = { amount = 2, what = "armaments" }, pay = { amount = 3, what = "wine" } },
      { get = { amount = 3, what = "kahwe" },     pay = { amount = 2, what = "wine" } },
    },
    ignore = false,
  },
  {
    name = "Zanzibaar",
    fee = 2000,
    trades = {
      { get = { amount = 3, what = "fruits" },  pay = { amount = 4, what = "ore" } },
      { get = { amount = 2, what = "tea" },     pay = { amount = 3, what = "terracotta" } },
      { get = { amount = 1, what = "spices" },  pay = { amount = 2, what = "armaments" } },
      { get = { amount = 2, what = "perfume" }, pay = { amount = 1, what = "gems" } },
      { get = { amount = 3, what = "incense" }, pay = { amount = 2, what = "armaments" } },
    },
    ignore = false,
  },
  {
    name = "Zaphar",
    fee = 100,
    trades = {
      { get = { amount = 1, what = "salt" },  pay = { amount = 1000, what = "gp" } },
      { get = { amount = 3, what = "sugar" }, pay = { amount = 4, what = "grain" } },
    },
    ignore = false,
  },
}
