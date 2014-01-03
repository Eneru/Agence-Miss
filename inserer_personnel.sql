-- MEYER, spécialiste en chevilles enflées
insert into personnel values (
    1,
    1,
    'directeur',
    10000.92
);

-- RAZ... ce nom qui overflow les buffer
insert into personnel values (
    2,
    2,
    'agent immobilier',
    2500
);

-- Melinda, secrétaire old school ( fervente utilisatrice de msn)
insert into personnel values (
    3,
    4,
    'secretaire',
    1050.12
);

-- ROUTE, admin dyslexique
insert into personnel values (
    4,
    6,
    'personnel administratif',
    1251.47
);

-- James, agent imm...wait. What.
insert into personnel values (
    5,
     10,
     'agent immobilier',
     20000
);
