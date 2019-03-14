unit spkt_Dispatch;


(*******************************************************************************
*                                                                              *
*  Plik: spkt_Dispatch.pas                                                     *
*  Opis: Bazowe klasy dyspozytorów poœrednicz¹cych pomiêdzy elementami         *
*        toolbara.                                                             *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u¿ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z³amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

interface

uses Classes, FMX.Controls, FMX.Graphics,
     SpkMath;

type TSpkBaseDispatch = class (TObject)
     private
     protected
     public
     end;

type TSpkBaseAppearanceDispatch = class (TSpkBaseDispatch)
     private
     protected
     public
       procedure NotifyAppearanceChanged; virtual; abstract;
     end;

type TSpkBaseToolbarDispatch = class (TSpkBaseAppearanceDispatch)
     private
     protected
     public
       procedure NotifyItemsChanged; virtual; abstract;
       procedure NotifyMetricsChanged; virtual; abstract;
       procedure NotifyVisualsChanged; virtual; abstract;
       function GetTempBitmap : TBitmap; virtual; abstract;
       function ClientToScreen(Point : T2DIntPoint) : T2DIntPoint; virtual; abstract;
     end;

implementation

end.
