#!/bin/bash

function first_loopback_mainmic(){
 tinymix 'TX DEC0 MUX' 'SWR_MIC'
 tinymix 'TX SMIC MUX0' 'SWR_MIC0'
 tinymix 'ADC1 ChMap' 'SWRM_TX1_CH1'
 tinymix 'ADC1_MIXER Switch' '1'
 tinymix 'TX_AIF1_CAP Mixer DEC0' '1'
 tinymix 'TX_DEC0 Volume' '0'

 tinymix 'IIR0 INP0 MUX' 'DEC0'
 tinymix 'IIR0 INP0 Volume' '0'
 tinymix 'RX INT0 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT1 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT0_1 MIX1 INP0' 'IIR0'
 tinymix 'RX INT1_1 MIX1 INP0' 'IIR0'
 tinymix 'RX_COMP1 Switch' '1'
 tinymix 'RX_COMP2 Switch' '1'
 tinymix 'HPHL_RDAC Switch' '1'
 tinymix 'HPHR_RDAC Switch' '1'
 tinymix 'HPHL_COMP Switch' '1'
 tinymix 'HPHR_COMP Switch' '1'
}

function second_loopback_mainmic(){
 tinymix 'TX DEC0 MUX' 'SWR_MIC'
 tinymix 'TX SMIC MUX0' 'SWR_MIC0'
 tinymix 'ADC1 ChMap' 'SWRM_TX1_CH1'
 tinymix 'ADC1_MIXER Switch' '1'
 tinymix 'TX_AIF1_CAP Mixer DEC0' '1'
 tinymix 'TX_DEC0 Volume' '74'


 tinymix 'IIR0 INP0 MUX' 'DEC0'
 tinymix 'IIR0 INP0 Volume' '54'
 tinymix 'RX INT0 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT1 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT0_1 MIX1 INP0' 'IIR0'
 tinymix 'RX INT1_1 MIX1 INP0' 'IIR0'
 tinymix 'RX_COMP1 Switch' '1'
 tinymix 'RX_COMP2 Switch' '1'
 tinymix 'HPHL_RDAC Switch' '1'
 tinymix 'HPHR_RDAC Switch' '1'
 tinymix 'HPHL_COMP Switch' '1'
 tinymix 'HPHR_COMP Switch' '1'
 }

 function first_loopback_submic(){
 tinymix 'TX DEC0 MUX' 'SWR_MIC'
 tinymix 'TX SMIC MUX0' 'SWR_MIC1'
 tinymix 'ADC2_MIXER Switch' '1'
 tinymix 'ADC2 MUX' 'INP3'
 tinymix 'ADC2 ChMap' 'SWRM_TX1_CH2'
 tinymix 'TX_AIF1_CAP Mixer DEC0' '1'
 tinymix 'TX_DEC0 Volume' '0'

 tinymix 'IIR0 INP0 MUX' 'DEC0'
 tinymix 'IIR0 INP0 Volume' '0'
 tinymix 'RX INT0 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT1 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT0_1 MIX1 INP0' 'IIR0'
 tinymix 'RX INT1_1 MIX1 INP0' 'IIR0'
 tinymix 'RX_COMP1 Switch' '1'
 tinymix 'RX_COMP2 Switch' '1'
 tinymix 'HPHL_RDAC Switch' '1'
 tinymix 'HPHR_RDAC Switch' '1'
 tinymix 'HPHL_COMP Switch' '1'
 tinymix 'HPHR_COMP Switch' '1'
}

function second_loopback_submic(){
 tinymix 'TX DEC0 MUX' 'SWR_MIC'
 tinymix 'TX SMIC MUX0' 'SWR_MIC1'
 tinymix 'ADC2_MIXER Switch' '1'
 tinymix 'ADC2 MUX' 'INP3'
 tinymix 'ADC2 ChMap' 'SWRM_TX1_CH2'
 tinymix 'TX_AIF1_CAP Mixer DEC0' '1'
 tinymix 'TX_DEC0 Volume' '74'

 tinymix 'IIR0 INP0 MUX' 'DEC0'
 tinymix 'IIR0 INP0 Volume' '54'
 tinymix 'RX INT0 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT1 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT0_1 MIX1 INP0' 'IIR0'
 tinymix 'RX INT1_1 MIX1 INP0' 'IIR0'
 tinymix 'RX_COMP1 Switch' '1'
 tinymix 'RX_COMP2 Switch' '1'
 tinymix 'HPHL_RDAC Switch' '1'
 tinymix 'HPHR_RDAC Switch' '1'
 tinymix 'HPHL_COMP Switch' '1'
 tinymix 'HPHR_COMP Switch' '1'
 }

 function first_loopback_headset(){
 tinymix 'TX DEC0 MUX' 'SWR_MIC'
 tinymix 'TX SMIC MUX0' 'SWR_MIC5'
 tinymix 'DEC0_BCS Switch' '1'
 tinymix 'ADC2_MIXER Switch' '1'
 tinymix 'ADC2 MUX' 'INP2'
 tinymix 'ADC2 ChMap' 'SWRM_TX2_CH2'
 tinymix 'MBHC ChMap' 'SWRM_TX3_CH3'
 tinymix 'BCS Channel' 'CH10'
 tinymix 'TX_AIF1_CAP Mixer DEC0' '1'
 tinymix 'TX_DEC0 Volume' '0'

 tinymix 'IIR0 INP0 MUX' 'DEC0'
 tinymix 'IIR0 INP0 Volume' '0'
 tinymix 'RX INT0 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT1 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT0_1 MIX1 INP0' 'IIR0'
 tinymix 'RX INT1_1 MIX1 INP0' 'IIR0'
 tinymix 'RX_COMP1 Switch' '1'
 tinymix 'RX_COMP2 Switch' '1'
 tinymix 'HPHL_RDAC Switch' '1'
 tinymix 'HPHR_RDAC Switch' '1'
 tinymix 'HPHL_COMP Switch' '1'
 tinymix 'HPHR_COMP Switch' '1'
}

function second_loopback_headset(){
 tinymix 'TX DEC0 MUX' 'SWR_MIC'
 tinymix 'TX SMIC MUX0' 'SWR_MIC5'
 tinymix 'DEC0_BCS Switch' '1'
 tinymix 'ADC2_MIXER Switch' '1'
 tinymix 'ADC2 MUX' 'INP2'
 tinymix 'ADC2 ChMap' 'SWRM_TX2_CH2'
 tinymix 'MBHC ChMap' 'SWRM_TX3_CH3'
 tinymix 'BCS Channel' 'CH10'
 tinymix 'TX_AIF1_CAP Mixer DEC0' '1'
 tinymix 'TX_DEC0 Volume' '74'

 tinymix 'IIR0 INP0 MUX' 'DEC0'
 tinymix 'IIR0 INP0 Volume' '54'
 tinymix 'RX INT0 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT1 DEM MUX' 'CLSH_DSM_OUT'
 tinymix 'RX INT0_1 MIX1 INP0' 'IIR0'
 tinymix 'RX INT1_1 MIX1 INP0' 'IIR0'
 tinymix 'RX_COMP1 Switch' '1'
 tinymix 'RX_COMP2 Switch' '1'
 tinymix 'HPHL_RDAC Switch' '1'
 tinymix 'HPHR_RDAC Switch' '1'
 tinymix 'HPHL_COMP Switch' '1'
 tinymix 'HPHR_COMP Switch' '1'
 }

function close_channel_loopback(){
 tinymix 'TX DEC0 MUX' 'MSM_DMIC'
 tinymix 'TX SMIC MUX0' 'ZERO'
 tinymix 'ADC1 ChMap' 'ZERO'
 tinymix 'ADC1_MIXER Switch' '0'
 tinymix 'DEC0_BCS Switch' '0'
 tinymix 'ADC2_MIXER Switch' '0'
 tinymix 'ADC2 ChMap' 'ZERO'
 tinymix 'MBHC ChMap' 'ZERO'
 tinymix 'TX_AIF1_CAP Mixer DEC0' '0'

 tinymix 'IIR0 INP0 MUX' 'ZERO'
 tinymix 'IIR0 INP0 Volume' '54'
 tinymix 'RX INT0 DEM MUX' 'NORMAL_DSM_OUT'
 tinymix 'RX INT0_1 MIX1 INP0' 'ZERO'
 tinymix 'RX INT1_1 MIX1 INP0' 'ZERO'
 tinymix 'RX_COMP1 Switch' '0'
 tinymix 'RX_COMP2 Switch' '0'
 tinymix 'HPHL_RDAC Switch' '0'
 tinymix 'HPHR_RDAC Switch' '0'
 tinymix 'HPHL_COMP Switch' '0'
 tinymix 'HPHR_COMP Switch' '0'
}

 function main(){
if [ "${1}" == "mainmic" ];then
    first_loopback_mainmic
    echo "wait first_loopback_mainmic pass"
    sleep 1s
    close_channel_loopback
    sleep 1s
    second_loopback_mainmic
    echo "wait second_loopback_mainmic pass"
fi

if [ "${1}" == "submic" ];then
    first_loopback_submic
    echo "wait first_loopback_submic pass"
    sleep 1s
    close_channel_loopback
    sleep 1s
    second_loopback_submic
    echo "wait second_loopback_submic pass"
fi

if [ "${1}" == "headset" ];then
    first_loopback_headset
    echo "wait first_loopback_headset pass"
    sleep 1s
    close_channel_loopback
    sleep 1s
    second_loopback_headset
    echo "wait second_loopback_headset pass"
fi

if [ "${1}" == "close" ];then
    close_channel_loopback
    echo "close close_channel_loopback finish"
fi
}

 main $@