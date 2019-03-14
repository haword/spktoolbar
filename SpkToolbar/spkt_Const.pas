unit spkt_Const;


(*******************************************************************************
*                                                                              *
*  Plik: spkt_Const.pas                                                        *
*  Opis: Sta³e wykorzystywane do obliczania geometrii toolbara                 *
*  Copyright: (c) 2009 by Spook. Jakiekolwiek u¿ycie komponentu bez            *
*             uprzedniego uzyskania licencji od autora stanowi z³amanie        *
*             prawa autorskiego!                                               *
*                                                                              *
*******************************************************************************)

interface

const // ****************
      // *** Elementy ***
      // ****************
  DROPDOWN_ARROW_WIDTH = 8;
  DROPDOWN_ARROW_HEIGHT = 8;

      LARGEBUTTON_DROPDOWN_FIELD_SIZE = 29;
      LARGEBUTTON_GLYPH_MARGIN = 1;
      LARGEBUTTON_CAPTION_HMARGIN = 3;
      LARGEBUTTON_MIN_WIDTH = 24;
      LARGEBUTTON_RADIUS = 4;
      LARGEBUTTON_BORDER_SIZE = 2;
      LARGEBUTTON_CHEVRON_HMARGIN = 4;
      LARGEBUTTON_CAPTION_TOP_RAIL = 45;
      LARGEBUTTON_CAPTION_BOTTOM_RAIL = 58;

      SMALLBUTTON_GLYPH_WIDTH = 16;
      SMALLBUTTON_BORDER_WIDTH = 2;
      SMALLBUTTON_HALF_BORDER_WIDTH = 1;
      SMALLBUTTON_PADDING = 2;
      SMALLBUTTON_DROPDOWN_WIDTH = 11;
      SMALLBUTTON_RADIUS = 4;
      SMALLBUTTON_MIN_WIDTH = 2 * SMALLBUTTON_PADDING + SMALLBUTTON_GLYPH_WIDTH;

      // ********************
      // *** Obszar tafli ***
      // ********************

      /// <summary>Maksymalna wysokoœæ obszaru, który mo¿e zaj¹æ zawartoœæ
      /// tafli z elementami</summary>
      MAX_ELEMENT_HEIGHT = 67;

      /// <summary>Wysokoœæ pojedynczego wiersza elementów tafli</summary>
      PANE_ROW_HEIGHT = 22;

      PANE_FULL_ROW_HEIGHT = 3 * PANE_ROW_HEIGHT;

      /// <summary>Wewnêtrzny pionowy margines pomiêdzy pierwszym elementem a
      /// tafl¹ w przypadku wersji jednowierszowej</summary>
      PANE_ONE_ROW_TOPPADDING = 22;
      /// <summary>Wewnêtrzny pionowy margines pomiêdzy ostatnim elementem
      /// a tafl¹ w przypadku wersji jednowierszowej</summary>
      PANE_ONE_ROW_BOTTOMPADDING = 23;

      /// <summary>Odleg³oœæ pomiêdzy wierszami w przypadku wersji dwuwierszowej
      /// </summary>
      PANE_TWO_ROWS_VSPACER = 7;
      /// <summary>Wewnêtrzny pionowy margines pomiêdzy pierwszym elementem a
      /// tafl¹ w przypadku wersji dwuwierszowej</summary>
      PANE_TWO_ROWS_TOPPADDING = 8;
      /// <summary>Wewnêtrzny pionowy margines pomiêdzy ostatnim elementem
      /// a tafl¹ w przypadku wersji dwuwierszowej</summary>
      PANE_TWO_ROWS_BOTTOMPADDING = 8;

      /// <summary>Odleg³oœæ pomiêdzy wierszami w przypadku wersji
      /// trzywierszowej</summary>
      PANE_THREE_ROWS_VSPACER = 0;
      /// <summary>Wewnêtrzny pionowy margines pomiêdzy pierwszym elementem a
      /// tafl¹ w przypadku wersji trzywierszowej</summary>
      PANE_THREE_ROWS_TOPPADDING = 0;
      /// <summary>Wewnêtrzny pionowy margines pomiêdzy ostatnim elementem
      /// a tafl¹ w przypadku wersji trzywierszowej</summary>
      PANE_THREE_ROWS_BOTTOMPADDING = 1;

      PANE_FULL_ROW_TOPPADDING = PANE_THREE_ROWS_TOPPADDING;

      PANE_FULL_ROW_BOTTOMPADDING = PANE_THREE_ROWS_BOTTOMPADDING;

      /// <summary>Odleg³oœæ pomiêdzy lew¹ krawêdzi¹ a pierwszym elementem
      /// tafli</summary>
      PANE_LEFT_PADDING = 2;

      /// <summary>Odleg³oœæ pomiêdzy ostatnim elementem tafli a praw¹ krawêdzi¹
      /// </summary>
      PANE_RIGHT_PADDING = 2;

      /// <summary>Odleg³oœæ pomiêdzy dwoma kolumnami wewn¹trz tafli</summary>
      PANE_COLUMN_SPACER = 4;

      /// <summary>Odleg³oœæ pomiêdzy dwoma osobnymi grupami wewnêtrz wiersza
      /// w tafli</summary>
      PANE_GROUP_SPACER = 4;

      // *************
      // *** Tafla ***
      // *************

      /// <summary>Wysokoœæ obszaru tytu³u tafli</summary>
      PANE_CAPTION_HEIGHT = 15;

      PANE_CORNER_RADIUS = 3;

      /// <summary>Szerokoœæ/wysokoœæ ramki tafli</summary>
      /// <remarks>Nie nale¿y zmieniaæ tej sta³ej!</remarks>
      PANE_BORDER_SIZE = 2;

      /// <summary>Po³owa szerokoœci ramki tafli</summary>
      /// <remarks>Nie nale¿y zmieniaæ tej sta³ej!</remarks>
      PANE_BORDER_HALF_SIZE = 1;

      /// <summary>Wysokoœæ ca³ej tafli (uwzglêdniaj¹c ramkê)</summary>
      PANE_HEIGHT = MAX_ELEMENT_HEIGHT + PANE_CAPTION_HEIGHT + 2 * PANE_BORDER_SIZE;

      /// <summary>Poziomy margines etykiety zak³adki</summary>
      PANE_CAPTION_HMARGIN = 6;

      // ***********************
      // *** Obszar zak³adki ***
      // ***********************

      /// <summary>Promieñ zaokr¹glenia zak³adki</summary>
      TAB_CORNER_RADIUS = 4;

      /// <summary>Lewy wewnêtrzny margines zak³adki</summary>
      TAB_PANE_LEFTPADDING = 2;
      /// <summary>Prawy wewnêtrzny margines zak³adki</summary>
      TAB_PANE_RIGHTPADDING = 2;
      /// <summary>Górny wewnêtrzny margines zak³adki</summary>
      TAB_PANE_TOPPADDING = 2;
      /// <summary>Dolny wewnêtrzny margines zak³adki</summary>
      TAB_PANE_BOTTOMPADDING = 1;
      /// <summary>Odleg³oœæ pomiêdzy taflami</summary>
      TAB_PANE_HSPACING = 3;

      /// <summary>Szerokoœæ/wysokoœæ ramki zak³adki (nie nale¿y zmieniaæ!)
      /// </summary>
      TAB_BORDER_SIZE = 1;
      /// <summary>Wysokoœæ zak³adki</summary>
      TAB_HEIGHT = PANE_HEIGHT + TAB_PANE_TOPPADDING + TAB_PANE_BOTTOMPADDING + TAB_BORDER_SIZE;

      // ***************
      // *** Toolbar ***
      // ***************

      TOOLBAR_BORDER_WIDTH = 1;

      TOOLBAR_CORNER_RADIUS = 3;

      /// <summary>Wysokoœæ etykiet z nazwami zak³adek</summary>
      TOOLBAR_TAB_CAPTIONS_HEIGHT = 22;
      /// <summary>Poziomy margines wewnêtrznego tytu³u zak³adki</summary>
      TOOLBAR_TAB_CAPTIONS_TEXT_HPADDING = 4;

      TOOLBAR_MIN_TAB_CAPTION_WIDTH = 32;

      /// <summary>Sumaryczna wysokoœæ toolbara</summary>
      TOOLBAR_HEIGHT = TOOLBAR_TAB_CAPTIONS_HEIGHT +
                       TAB_HEIGHT;

implementation

initialization

{$IFDEF DEBUG}
// Sprawdzanie poprawnoœci

// £uk du¿ego przycisku
assert(LARGEBUTTON_RADIUS * 2 <= LARGEBUTTON_DROPDOWN_FIELD_SIZE);

// Tafla, wersja z jednym wierszem
assert(PANE_ROW_HEIGHT +
       PANE_ONE_ROW_TOPPADDING +
       PANE_ONE_ROW_BOTTOMPADDING <= MAX_ELEMENT_HEIGHT);

// Tafla, wersja z dwoma wierszami
assert(2*PANE_ROW_HEIGHT +
       PANE_TWO_ROWS_TOPPADDING +
       PANE_TWO_ROWS_VSPACER +
       PANE_TWO_ROWS_BOTTOMPADDING <= MAX_ELEMENT_HEIGHT);

// Tafla, wersja z trzema wierszami
assert(3*PANE_ROW_HEIGHT +
       PANE_THREE_ROWS_TOPPADDING +
       2*PANE_THREE_ROWS_VSPACER +
       PANE_THREE_ROWS_BOTTOMPADDING <= MAX_ELEMENT_HEIGHT);
{$ENDIF}

end.
