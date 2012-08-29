<Archive>
<!--

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
-->
 <Option name="syntaxCheck" value="1"/>
 <Module name="x1">
  <Attribute name="m1">
EXPORT m1 := MODULE
   EXPORT major := 1;
   EXPORT minor := syntaxError;
   EXPORT version := (string)major + '.' + (string)minor;
END;
  </Attribute>
 </Module>
 <Query attributePath="x1.m1"/>
</Archive>
