;************* Macros ****************
BANK0 MACRO
    bcf STATUS, RP0
    bcf STATUS, RP1
    ENDM

BANK1 MACRO
    bsf STATUS, RP0
    bcf STATUS, RP1
    ENDM

BANK2 MACRO
    bcf STATUS, RP0
    bsf STATUS, RP1
    ENDM

BANK3 MACRO
    bsf STATUS, RP0
    bsf STATUS, RP1
    ENDM
;*************************************