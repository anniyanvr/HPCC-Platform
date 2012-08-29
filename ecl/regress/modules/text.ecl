/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

RETURN MODULE

export PATTERN AlphaUpper := PATTERN('[A-Z]');
export PATTERN AlphaLower := PATTERN('[a-z]');
export pattern Alpha := PATTERN('[A-Za-z]');
export pattern sws := PATTERN('[ \t\r\n]');
export pattern ws := sws+;
export pattern pws := PATTERN('[ ,.();:\t\r\n]');
export pattern digit := PATTERN('[0-9]');

export Countries := ['AFGHANISTAN',
'ALBANIA',
'ALGERIA',
'AMERICAN SAMOA',
'ANDORRA',
'ANGOLA',
'ANGUILLA',
'ANTARCTICA',
'ANTIGUA AND BARBUDA',
'ARGENTINA',
'ARMENIA',
'ARUBA',
'AUSTRALIA',
'AUSTRIA',
'AZERBAIJAN',
'BAHAMAS',
'BAHRAIN',
'BANGLADESH',
'BARBADOS',
'BELARUS',
'BELGIUM',
'BELIZE',
'BENIN',
'BERMUDA',
'BHUTAN',
'BOLIVIA',
'BOSNIA AND HERZEGOVINA',
'BOTSWANA',
'BOUVET ISLAND',
'BRAZIL',
'BRITISH INDIAN OCEAN TERRITORY',
'BRUNEI DARUSSALAM',
'BULGARIA',
'BURKINA FASO',
'BURUNDI',
'CAMBODIA',
'CAMEROON',
'CANADA',
'CAPE VERDE',
'CAYMAN ISLANDS',
'CENTRAL AFRICAN REPUBLIC',
'CHAD',
'CHILE',
'CHINA',
'CHRISTMAS ISLAND',
'COCOS (KEELING) ISLANDS',
'COLOMBIA',
'COMOROS',
'CONGO',
'CONGO, THE DEMOCRATIC REPUBLICTHE',
'COOK ISLANDS',
'COSTA RICA',
'CROATIA',
'CUBA',
'CYPRUS',
'CZECH REPUBLIC',
'DENMARK',
'DJIBOUTI',
'DOMINICA',
'DOMINICAN REPUBLIC',
'ECUADOR',
'EGYPT',
'EL SALVADOR',
'EQUATORIAL GUINEA',
'ERITREA',
'ESTONIA',
'ETHIOPIA',
'FALKLAND ISLANDS (MALVINAS)',
'FAROE ISLANDS',
'FIJI',
'FINLAND',
'FRANCE',
'FRENCH GUIANA',
'FRENCH POLYNESIA',
'FRENCH SOUTHERN TERRITORIES',
'GABON',
'GAMBIA',
'GEORGIA',
'GERMANY',
'GHANA',
'GIBRALTAR',
'GREECE',
'GREENLAND',
'GRENADA',
'GUADELOUPE',
'GUAM',
'GUATEMALA',
'GUINEA',
'GUINEA-BISSAU',
'GUYANA',
'HAITI',
'HEARD ISLAND AND MCDONALD ISLANDS',
'HOLY SEE (VATICAN CITY STATE)',
'HONDURAS',
'HONG KONG',
'HUNGARY',
'ICELAND',
'INDIA',
'INDONESIA',
'IRAN, ISLAMIC REPUBLIC',
'IRAQ',
'IRELAND',
'ISRAEL',
'ITALY',
'JAMAICA',
'JAPAN',
'JORDAN',
'KAZAKHSTAN',
'KENYA',
'KIRIBATI',
'KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC',
'KOREA, REPUBLIC',
'KUWAIT',
'KYRGYZSTAN',
'LAO PEOPLE\'S DEMOCRATIC REPUBLIC',
'LATVIA',
'LEBANON',
'LESOTHO',
'LIBERIA',
'LIBYAN ARAB JAMAHIRIYA',
'LIECHTENSTEIN',
'LITHUANIA',
'LUXEMBOURG',
'MACAO',
'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC',
'MADAGASCAR',
'MALAWI',
'MALAYSIA',
'MALDIVES',
'MALI',
'MALTA',
'MARSHALL ISLANDS',
'MARTINIQUE',
'MAURITANIA',
'MAURITIUS',
'MAYOTTE',
'MEXICO',
'MICRONESIA, FEDERATED STATES',
'MOLDOVA, REPUBLIC',
'MONACO',
'MONGOLIA',
'MONTSERRAT',
'MOROCCO',
'MOZAMBIQUE',
'MYANMAR',
'NAMIBIA',
'NAURU',
'NEPAL',
'NETHERLANDS',
'NETHERLANDS ANTILLES',
'NEW CALEDONIA',
'NEW ZEALAND',
'NICARAGUA',
'NIGER',
'NIGERIA',
'NIUE',
'NORFOLK ISLAND',
'NORTHERN MARIANA ISLANDS',
'NORWAY',
'OMAN',
'PAKISTAN',
'PALAU',
'PALESTINIAN TERRITORY, OCCUPIED',
'PANAMA',
'PAPUA NEW GUINEA',
'PARAGUAY',
'PERU',
'PHILIPPINES',
'PITCAIRN',
'POLAND',
'PORTUGAL',
'PUERTO RICO',
'QATAR',
//'RÉUNION',
'ROMANIA',
'RUSSIAN FEDERATION',
'RWANDA',
'SAINT HELENA',
'SAINT KITTS AND NEVIS',
'SAINT LUCIA',
'SAINT PIERRE AND MIQUELON',
'SAINT VINCENT AND THE GRENADINES',
'SAMOA',
'SAN MARINO',
'SAO TOME AND PRINCIPE',
'SAUDI ARABIA',
'SENEGAL',
'SERBIA AND MONTENEGRO',
'SEYCHELLES',
'SIERRA LEONE',
'SINGAPORE',
'SLOVAKIA',
'SLOVENIA',
'SOLOMON ISLANDS',
'SOMALIA',
'SOUTH AFRICA',
'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS',
'SPAIN',
'SRI LANKA',
'SUDAN',
'SURINAME',
'SVALBARD AND JAN MAYEN',
'SWAZILAND',
'SWEDEN',
'SWITZERLAND',
'SYRIAN ARAB REPUBLIC',
'TAIWAN, PROVINCECHINA',
'TAJIKISTAN',
'TANZANIA, UNITED REPUBLIC',
'THAILAND',
'TIMOR-LESTE',
'TOGO',
'TOKELAU',
'TONGA',
'TRINIDAD AND TOBAGO',
'TUNISIA',
'TURKEY',
'TURKMENISTAN',
'TURKS AND CAICOS ISLANDS',
'TUVALU',
'UGANDA',
'UKRAINE',
'UNITED ARAB EMIRATES',
'UNITED KINGDOM',
'ENGLAND',
'WALES',
'GREAT BRITAIN',
'UK',
'UNITED STATES',
'US',
'USA',
'UNITED STATES MINOR OUTLYING ISLANDS',
'URUGUAY',
'UZBEKISTAN',
'VANUATU',
'Vatican City State see HOLY SEE',
'VENEZUELA',
'VIET NAM',
'VIRGIN ISLANDS, BRITISH',
'VIRGIN ISLANDS, U.S.',
'WALLIS AND FUTUNA',
'WESTERN SAHARA',
'YEMEN',
'ZAIRE',
'ZAMBIA',
'ZIMBABWE'];

export Countries_Poss := [
'AFGHANI',
'ALBANIAN',
'ALGERIAN',
'AMERICAN',
'ANGOLAN',
'AUSTRALIAN',
'ARGENTINIAN',
'ARMENIAN',
'AUSTRIAN',
'AUSTRALIAN',
'BANGLADESHI',
'BOLIVIAN',
'BOSNIAN',
'BRAZILIAN',
'BRITISH',
'BULGARIAN',
'BURUNDIAN',
'CAMBODIAN',
'CANADIAN',
'CHILEAN',
'CHINESE',
'COLUMBIAN',
'COSTA RICAN',
'CROATIAN',
'CUBAN',
'DANISH',
'DOMINICAN',
'DUTCH',
'FRENCH',
'EGYPTIAN',
'ENGLISH',
'ERITREAN',
'ESTONIAN',
'ETHIOPIAN',
'FIJIAN',
'FINNISH',
'FRENCH',
'GAMBIAN',
'GERMAN',
'GHANIAN',
'GREEK',
'GUATEMALAN',
'GUINEAN',
'HAITIAN',
'HONDURAN',
'HUNGARIAN',
'INDIAN',
'INDONESIAN',
'IRANIAN',
'IRAQI',
'IRISH',
'ISRAELI',
'ITALIAN',
'JAMAICAN',
'JAPANESE',
'JORDANIAN',
'KAZAKHSTANI',
'KENYAN',
'KOREAN',
'KUWAITI',
'LATVIAN',
'LEBANESE',
'LEONEAN',
'LIBERIAN',
'LIBYAN',
'LITHUANIAN',
'MACEDONIAN',
'MALAYSIAN',
'MAURITANIAN',
'MEXICAN',
'MONACAN',
'MONGOLIAN',
'MOROCCAN',
'NAMIBIAN',
'NEPALESE',
'NICARAGUAN',
'NIGERIAN',
'NORTH KOREAN',
'NORWEGIAN',
'OMANI',
'PAKASTANI',
'PALESTINIAN',
'PALESTINIAN AUTHORITY',
'PANAMANIAN',
'PERUVIAN',
'PHILIPPINO',
'POLISH',
'PORTUGESE',
'PUERTO RICAN',
'ROMANIAN',
'RWANDAN',
'RUSSIAN',
'SAINT LUCIAN',
'SAMOAN',
'SAUDI',
'SAUDI ARABIAN',
'SCOTTISH',
'SENEGALESE',
'SERBIAN',
'SIERRA LEONEAN',
'SINGAPOREAN',
'SLOVAKIAN',
'SLOVENIAN',
'SOMALIAN',
'SOUTH AFRICAN',
'SOUTH KOREAN',
'SPANISH',
'SRI LANKAN',
'SUDANESE',
'SWEDISH',
'SWISS',
'SYRIAN',
'TAIWANESE',
'TAJIKISTANI',
'TANZANIAN',
'THAI',
'TONGAN',
'TUNISIAN',
'TURKISH',
'TURKMENISTANI',
'UGANDAN',
'UK',
'UKRAINIAN',
'U.N.',
'UNITED STATES',
'URUGUAN',
'US',
'U.S.',
'UZBEKISTANI',
'VENEZUELAN',
'VIETNAMESE',
'WELSH',
'YEMENI',
'ZAMBIAN',
'ZIMBABWEAN'
];
export pattern word := (alpha|'-')+;

export pattern proper_noun := AlphaUpper word;

END;
