export default {
  id: null,
  enabled: false,
  name: null,
  children: [
    {
      id: 'aml',
      enabled: true,
      name: 'Anti-Money Laundering',
      children: [
        {
          id: 'aml-training',
          enabled: false,
          name: 'Training, Responsible Persons / Departments',
          children: []
        },
        {
          id: 'aml-disclosure',
          enabled: true,
          name: 'Disclosure, Reporting (including STR)',
          children: []
        },
        {
          id: 'aml-powers',
          enabled: false,
          name: 'Authorities: Scope, Powers & Obligations',
          children: []
        },
        {
          id: 'aml-edd',
          enabled: false,
          name: 'EDD High Risk Customers',
          children: []
        },
        {
          id: 'aml-laundering',
          enabled: false,
          name: 'Money Laundering & Associated Offences',
          children: []
        },
        {
          id: 'aml-recording',
          enabled: true,
          name: 'Record Keeping',
          children: []
        },
        {
          id: 'aml-intermediary',
          enabled: false,
          name: 'Intermediary-led Enforcement Measures',
          children: []
        },
        {
          id: 'aml-regulated',
          enabled: false,
          name: 'Regulated Entities & Activities',
          children: []
        },
        {
          id: 'aml-terrorism',
          enabled: false,
          name: 'Terrorism Financing',
          children: []
        },
        {
          id: 'aml-authority',
          enabled: true,
          name: 'Authority’s Enforcement, Remedial Measures & Penalties',
          children: []
        },
        {
          id: 'aml-cdd',
          enabled: true,
          name: 'CDD, ID & Verification',
          children: []
        }
      ]
    },
    {
      id: 'ctf',
      enabled: false,
      name: 'Counter-Terrorism Financing',
      children: []
    },
    {
      id: 'tp',
      enabled: false,
      name: 'Transfer Pricing',
      children: []
    },
    {
      id: 'mm',
      enabled: false,
      name: 'Mobile Money',
      children: []
    },
    {
      id: 'em',
      enabled: false,
      name: 'Electronic Money',
      children: []
    },
    {
      id: 'pm',
      enabled: false,
      name: 'Payments',
      children: []
    },
    {
      id: 'rm',
      enabled: false,
      name: 'Remittances',
      children: []
    },
    {
      id: 'fx',
      enabled: false,
      name: 'Foreign Exchange',
      children: []
    },
    {
      id: 'mf',
      enabled: false,
      name: 'Microfinance',
      children: []
    },
    {
      id: 'cc',
      enabled: false,
      name: 'Consumer Credit',
      children: []
    },
    {
      id: 'bl',
      enabled: false,
      name: 'Business Lending',
      children: []
    },
    {
      id: 'scf',
      enabled: false,
      name: 'Supply Chain Finance',
      children: []
    },
    {
      id: 'if',
      enabled: false,
      name: 'Islamic Finance',
      children: []
    },
    {
      id: 'crs',
      enabled: false,
      name: 'Credit Reference Services',
      children: []
    },
    {
      id: 'ec',
      enabled: false,
      name: 'Equity Crowdfunding',
      children: []
    },
    {
      id: 'po',
      enabled: false,
      name: 'Public Offers',
      children: []
    },
    {
      id: 'di',
      enabled: false,
      name: 'Dealing in Investments',
      children: []
    },
    {
      id: 'dp',
      enabled: false,
      name: 'Data Protection',
      children: []
    },
    {
      id: 'ra',
      enabled: false,
      name: 'Robo Advice',
      children: []
    },
    {
      id: 'ca',
      enabled: false,
      name: 'Crypto-Assets',
      children: []
    },
    {
      id: 'rb',
      enabled: false,
      name: 'Retail Banking',
      children: []
    },
    {
      id: 'mi',
      enabled: false,
      name: 'Managing Investments',
      children: []
    },
    {
      id: 'im',
      enabled: false,
      name: 'Insurance Mediation',
      children: []
    }
  ]
};
