unit spkt_Exceptions;


(*******************************************************************************
*                                                                              *
*  Plik: spkt_Exceptions.pas                                                   *
*  Opis: Klasy wyj¹tków toolbara                                               *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u¿ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z³amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

interface

uses SysUtils;

type InternalException = class(Exception);
     AssignException = class(Exception);
     RuntimeException = class(Exception);
     ListException = class(Exception);

implementation

end.
