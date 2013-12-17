library LinkedList;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  System,
  TOperativeUnit in 'TOperativeUnit.pas';

{$R *.res}



  
var
  gHead : PElem;

procedure Append(item : TElemType); stdcall;
var
  newNode : PElem;
  iter : PElem;
begin
  if gHead = nil then
  begin
    //if list is empty, create it
    New(gHead);
    gHead^.Next := nil;
    gHead^.Val := item;
    Exit;
  end;
  //otherwise, find tail and append new element to it
  iter := gHead;
  while(iter^.Next <> nil) do
  begin
    iter := iter^.Next;
  end;
  New(newNode);
  newNode^.Next := nil;
  newNode^.Val := item;

  iter^.Next := newNode;
end;

procedure WriteEach; stdcall;
var
  iter : PElem;
begin
  //check if empty
  if gHead = nil then
  begin
    writeln('Empty');
    Exit;
  end;
   
  iter := gHead;
   
  while iter <> nil do
  begin
    writeln(iter^.Val.FirstName);
    iter := iter^.Next;
  end;

end;

procedure Seed; stdcall;
var
  bolek, stokrotka, michau : TOperative;
begin
  bolek.FirstName := 'Lech';
  stokrotka.FirstName := 'Monika';
  michau.FirstName := 'Michau';
  Append(bolek);
  Append(michau);
  Append(stokrotka);
end;

//TODO: check if list is empty 

procedure WriteToFile; stdcall;
var
  f : File of TOperative;
  iter : PElem;
begin
  AssignFile(f, 'database.dat');
  Rewrite(f);

 try
 begin
    //go through all entries and save them to file
    iter := gHead;
    while iter <> nil do
    begin
      Write(f, iter^.Val);
      iter := iter^.Next;
    end;
  end;
  finally
    CloseFile(f);
  end; 
end;

//TODO: Exception handling ?

procedure ReadFromFile; stdcall;
var
  f : File of TOperative;
  entry : TOperative;
begin
  AssignFile(f, 'database.dat');
  Reset(f);

  try
  begin
    while not EOF(f) do
    begin
      Read(f, entry);
      Append(entry);
    end;
  end;

  finally
    CloseFile(f);
  end;
end;

function GetHead : PElem; stdcall;
begin
  Result := gHead;
end;

exports 
  Append name 'Append',
  WriteEach name 'WriteEach',
  WriteToFile name 'WriteToFile',
  ReadFromFile name 'ReadFromFile',
  GetHead name 'GetHead',
  Seed name 'Seed';

begin
  gHead := nil;
end.


