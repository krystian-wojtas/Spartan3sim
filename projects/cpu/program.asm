%include "instructions.asm"

restart:
LDI(00110011b)				; zaladowanie jedynki do akumulatora
rotate:
ST(0)				; przepisanie aktualnego stanu akumulatora do pamieci pod adres 0, zapalenie odpowiadajacych sobie diod
LR				; obrocenie rejestru akumulatora w lewo
JMP(rotate)			; ponowne obroty wykonywany nieskonczenie
