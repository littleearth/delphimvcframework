{ *************************************************************************** }
{ }
{ Delphi MVC Framework }
{ }
{ Copyright (c) 2010-2015 Daniele Teti and the DMVCFramework Team }
{ }
{ https://github.com/danieleteti/delphimvcframework }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ This IDE expert is based off of the one included with the DUnitX }
{ project.  Original source by Robert Love.  Adapted by Nick Hodges. }
{ }
{ The DUnitX project is run by Vincent Parrett and can be found at: }
{ }
{ https://github.com/VSoftTechnologies/DUnitX }
{ *************************************************************************** }

unit DMVC.Expert.CodeGen.NewControllerUnit;

interface

uses
  ToolsApi,
  DMVC.Expert.CodeGen.NewUnit;

type
  TNewControllerUnitEx = class(TNewUnit)
  protected
    FCreateIndexMethod: Boolean;
    FCreateActionFiltersMethods: Boolean;
    FControllerClassName: String;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;
  public
    constructor Create(const aCreateIndexMethod, aCreateActionFiltersMethods
      : Boolean; const AControllerClassName: String;
      const APersonality: String = '');
  end;

implementation

uses
  System.SysUtils,
  VCL.Dialogs,
  DMVC.Expert.CodeGen.Templates,
  DMVC.Expert.CodeGen.SourceFile;

constructor TNewControllerUnitEx.Create(const aCreateIndexMethod,
  aCreateActionFiltersMethods: Boolean; const AControllerClassName: String;
  const APersonality: String = '');
begin
  Assert(Length(AControllerClassName) > 0);
  FAncestorName := '';
  FFormName := '';
  FImplFileName := '';
  FIntfFileName := '';
  FControllerClassName := AControllerClassName;
  FCreateIndexMethod := aCreateIndexMethod;
  FCreateActionFiltersMethods := aCreateActionFiltersMethods;
  Personality := APersonality;
end;

function TNewControllerUnitEx.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  lUnitIdent: string;
  lFormName: string;
  lFileName: string;
  lIndexMethodIntf: string;
  lIndexMethodImpl: string;
  lControllerUnit: string;
  lActionFiltersMethodsIntf: string;
  lActionFiltersMethodsImpl: string;
begin
  lControllerUnit := sControllerUnit;
  lIndexMethodIntf := sIndexMethodIntf;
  lIndexMethodImpl := Format(sIndexMethodImpl, [FControllerClassName]);

  if not FCreateIndexMethod then
  begin
    lIndexMethodIntf := '';
    lIndexMethodImpl := '';
  end;

  lActionFiltersMethodsIntf := sActionFiltersIntf;
  lActionFiltersMethodsImpl := Format(sActionFiltersImpl,
    [FControllerClassName]);

  if not FCreateActionFiltersMethods then
  begin
    lActionFiltersMethodsIntf := '';
    lActionFiltersMethodsImpl := '';
  end;

  // http://stackoverflow.com/questions/4196412/how-do-you-retrieve-a-new-unit-name-from-delphis-open-tools-api
  // So using method mentioned by Marco Cantu.
  (BorlandIDEServices as IOTAModuleServices).GetNewModuleAndClassName('',
    lUnitIdent, lFormName, lFileName);
  Result := TSourceFile.Create(sControllerUnit,
    [lUnitIdent, FControllerClassName, lIndexMethodIntf, lIndexMethodImpl, lActionFiltersMethodsIntf, lActionFiltersMethodsImpl]);
end;

end.
