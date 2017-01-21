/*
 This project is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Multiprotocol is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Multiprotocol.  If not, see <http://www.gnu.org/licenses/>.
 */

/** Multiprotocol module configuration file ***/

/* TX type */
/* #define TX_ER9X_AETR */
#define TX_TARANIS

/* Installed modules */
#define A7105_INSTALLED
#define CYRF6936_INSTALLED
#define CC2500_INSTALLED
#define NFR24L01_INSTALLED

/* Selected protocols */
#ifdef  A7105_INSTALLED
  #define FLYSKY_A7105_INO
  #define HUBSAN_A7105_INO
#endif
#ifdef  CYRF6936_INSTALLED
  /* #define DEVO_CYRF6936_INO */
  #define DSM2_CYRF6936_INO
#endif
#ifdef  CC2500_INSTALLED
  #define FRSKY_CC2500_INO
  #define FRSKYX_CC2500_INO
  /* #define SFHSS_CC2500_INO */
#endif
#ifdef  NFR24L01_INSTALLED
  /* #define BAYANG_NRF24L01_INO */
  /* #define CG023_NRF24L01_INO */
  /* #define CX10_NRF24L01_INO */
  /* #define ESKY_NRF24L01_INO */
  /* #define HISKY_NRF24L01_INO */
  /* #define KN_NRF24L01_INO */
  /* #define SLT_NRF24L01_INO */
  #define SYMAX_NRF24L01_INO
  /* #define V2X2_NRF24L01_INO */
  /* #define YD717_NRF24L01_INO */
  /* #define MT99XX_NRF24L01_INO */
  /* #define MJXQ_NRF24L01_INO */
  /* #define SHENQI_NRF24L01_INO */
  /* #define FY326_NRF24L01_INO */
#endif

/* Enable telemetry */
/* #define TELEMETRY */

/* Telemetry protocols */
#if defined(TELEMETRY)
  #if defined DSM2_CYRF6936_INO
    #define DSM_TELEMETRY
  #endif
  #if defined FRSKYX_CC2500_INO
    #define SPORT_TELEMETRY
  #endif
  #if defined FRSKY_CC2500_INO
    #define HUB_TELEMETRY
  #endif
#endif

/* Dial protocols */
const PPM_Parameters PPM_prot[15] = {
/* protocol, sub protocol, RX num, power, auto bind, option */
  {MODE_HUBSAN, 0      , 0, P_HIGH, NO_AUTOBIND, 0},
  {MODE_SYMAX , SYMAX  , 0, P_HIGH, NO_AUTOBIND, 0},
  {MODE_FLYSKY, Flysky , 0, P_HIGH, NO_AUTOBIND, 0},
  {MODE_DSM2  , DSM2   , 0, P_HIGH, NO_AUTOBIND, 6},
  {MODE_DSM2  , DSMX   , 0, P_HIGH, NO_AUTOBIND, 6}
};

/*
Available protocols and associated sub protocols:
  MODE_FLYSKY
    Flysky
    V9X9
    V6X6
    V912
  MODE_HUBSAN
    NONE
  MODE_FRSKY
    NONE
  MODE_HISKY
    Hisky
    HK310
  MODE_V2X2
    NONE
  MODE_DSM2
    DSM2
    DSMX
  MODE_DEVO
    NONE
  MODE_YD717
    YD717
    SKYWLKR
    SYMAX4
    XINXUN
    NIHUI
  MODE_KN
    WLTOYS
    FEILUN
  MODE_SYMAX
    SYMAX
    SYMAX5C
  MODE_SLT
    NONE
  MODE_CX10
    CX10_GREEN
    CX10_BLUE
    DM007
    Q282
    JC3015_1
    JC3015_2
    MK33041
    Q242
  MODE_CG023
    CG023
    YD829
    H8_3D
  MODE_BAYANG
    NONE
  MODE_FRSKYX
    CH_16
    CH_8
  MODE_ESKY
    NONE
  MODE_MT99XX
    MT99
    H7
    YZ
  MODE_MJXQ
    WLH08
    X600
    X800
    H26D
  MODE_SHENQI
    NONE
  MODE_FY326
    NONE
  MODE_SFHSS
    NONE

RX num: 0-15
power: P_HIGH or P_LOW
auto bind: AUTOBIND or NO_AUTOBIND
option: 0-255
*/

/* Turnigy TX definition */
#if defined(TX_ER9X_AETR)
#define PPM_MAX     2140  // 125%
#define PPM_MIN     860   // 125%
#define PPM_MAX_100 2012  // 100%
#define PPM_MIN_100 988   // 100%
enum chan_order{
  AILERON =0,
  ELEVATOR,
  THROTTLE,
  RUDDER,
  AUX1,
  AUX2,
  AUX3,
  AUX4,
  AUX5,
  AUX6,
  AUX7,
  AUX8,
  AUX9
};
#endif

/* TARANIS TX definition */
#if defined(TX_TARANIS)
#define PPM_MAX     2000  // 125%
#define PPM_MIN     1000  // 125%
#define PPM_MAX_100 1900  // 100%
#define PPM_MIN_100 1100  // 100%
enum chan_order{
  THROTTLE=0,
  AILERON,
  ELEVATOR,
  RUDDER,
  AUX1,
  AUX2,
  AUX3,
  AUX4,
  AUX5,
  AUX6,
  AUX7,
  AUX8,
  AUX9
};
#endif

#define PPM_MIN_COMMAND 1250
#define PPM_SWITCH    1550
#define PPM_MAX_COMMAND 1750

/* Serial speed */
#define BAUD 100000
/* #define BAUD 125000 */
