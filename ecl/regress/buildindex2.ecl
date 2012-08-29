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


mainRecord :=
        RECORD
integer8            sequence;
string20            forename;
string20            surname;
string20            occupation;
unsigned8           filepos{virtual(fileposition)};
        END;

mainTable := dataset('keyed.d00',mainRecord,THOR);

BUILDINDEX(mainTable, { surname, forename, filepos }, 'keyed.name',overwrite);
//BUILDINDEX(mainTable, { sequence, filepos }, 'sequence.idx');

x := table(mainTable, {surname, forename, filepos }) : stored('stored');

BUILDINDEX(x, { surname, forename } , {filepos}, 'keyed.stored', dedup);
