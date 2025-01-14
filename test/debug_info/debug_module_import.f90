!
! Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
! See https://llvm.org/LICENSE.txt for license information.
! SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
!

! RUN: %flang -g -S -emit-llvm %s -o - | FileCheck %s
module first
integer :: var1 = 37
end module

module second
use first
integer :: var2 = 47
contains
function init()
  var2 = var2 - var1
end function
end module

program hello
use second
print *, var1
print *, var2
end program hello

! CHECK: ![[DBG_MOD1:[0-9]+]] = !DIModule({{.*}}, name: "first"
! CHECK: ![[DBG_DIC:[0-9]+]] = distinct !DICompileUnit({{.*}}, imports: ![[DBG_IMPORTS:[0-9]+]], nameTableKind: None
! CHECK: ![[DBG_MOD2:[0-9]+]] = !DIModule({{.*}}, name: "second"
! CHECK: ![[DBG_IMPORTS]] = !{![[DBG_IE1:[0-9]+]], ![[DBG_IE2:[0-9]+]], ![[DBG_IE3:[0-9]+]]}
! CHECK: ![[DBG_IE1]] = !DIImportedEntity(tag: DW_TAG_imported_module, scope: ![[DBG_SP1:[0-9]+]], entity: ![[DBG_MOD1]],
! CHECK: ![[DBG_SP1]] = distinct !DISubprogram(name: "init", scope: ![[DBG_MOD2]]
! CHECK: ![[DBG_IE2]] = !DIImportedEntity(tag: DW_TAG_imported_module, scope: ![[DBG_SP2:[0-9]+]], entity: ![[DBG_MOD1]],
! CHECK: ![[DBG_SP2]] = distinct !DISubprogram(name: "hello", scope: ![[DBG_DIC]]
! CHECK: ![[DBG_IE3]] = !DIImportedEntity(tag: DW_TAG_imported_module, scope: ![[DBG_SP2]], entity: ![[DBG_MOD2]],
