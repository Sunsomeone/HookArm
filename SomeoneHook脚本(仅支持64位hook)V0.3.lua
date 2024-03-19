--------------------------------------初始化---------------------------------------
gg.require("101.1")
local pkg,name,x64,x
local show = true
local getInfo = gg.getTargetInfo()
if getInfo.x64 then x64 = true x = "64" else x64 = false x = "32" end
pkg = getInfo.packageName
name = getInfo.label
if x64 == false then gg.alert('目前仅支持64位') os.exit() end
local File = gg.getFile()
File = File:match('.*/')
local HookTable = {['HookAddr'] = {},['StackAddr'] = {}}
local mincore = {}
--------------------------------------hook汇编---------------------------------------
function CreatHookMemory()
    local HookAddr,StackAddr = nil,nil
    if StackAddr == nil or HookAddr == nil then
        HookAddr = gg.allocatePage(gg.PROT_READ | gg.PROT_EXEC | gg.PROT_WRITE)
        StackAddr = gg.allocatePage(gg.PROT_READ | gg.PROT_EXEC | gg.PROT_WRITE)
    end
    local Register = SetHookRegister()
    local choice = gg.choice({'输入地址','读取保存列表选择项','读取地址列表选择项','返回'},nil,'设置的寄存器: X'..Register..'\n分配的内存页: '..string.format('%X',HookAddr))
    if choice == nil then return nil end
    if choice == 1 then
        local input = gg.prompt({'请输入地址(不需要加0x)'},{},{[1]='text'})
        if input == nil then return nil end
        if input[1] == '' then gg.alert('你没有输入内容') return nil end
        ArmAddr = '0x'..input
        local TextType = type(tonumber(ArmAddr))
        if TextType == nil then
            gg.alert('你输入的地址不对')
            return nil
        elseif ArmAddr == '0x' then
            gg.alert('你没有输入内容')
            return nil
        elseif TextType == number then
            HookArm(Register,ArmAddr,HookAddr,StackAddr)
            return nil
        end
    end
    if choice == 2 then
        local SelectedItem = gg.getSelectedListItems()
        if #SelectedItem == 0 then
            gg.alert('你的保存列表没有选择项')
            return nil
        else
            ArmAddr = SelectedItem[1].address
            HookArm(Register,ArmAddr,HookAddr,StackAddr)
            return nil
        end
    end
    if choice == 3 then
        local SelectedItem = gg.getSelectedElements()
        if #SelectedItem == 0 then
            gg.alert('你的地址列表没有选择项')
            return nil
        else
            ArmAddr = SelectedItem[1]
            HookArm(Register,ArmAddr,HookAddr,StackAddr)
            return nil
        end
    end
end

function HookArm(Register,ArmAddr,HookAddr,StackAddr)
    ArmTable,ArmAddr = JumpFind(ArmAddr)
    if ArmTable == nil then gg.alert('无法Hook\nHook的地方可能存在RET返回或跳转指令') return nil end
    gg.addListItems({{['flags']=gg.TYPE_DWORD,['address']=StackAddr}})
    gg.addListItems({{['flags']=gg.TYPE_DWORD,['address']=HookAddr}})
    gg.addListItems({{['flags']=gg.TYPE_DWORD,['address']=ArmAddr}})
    local HookAllAddr = HookAddr
    for i=1,16 do
        local Nop = {
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+4},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+8},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+12},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+16},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+20},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+24},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+28},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+32},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+36},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+40},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+44},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+48},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+52},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+56},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+60},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+64},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+68},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+72},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+76},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+80},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+84},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+88},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+92},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+96},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+100},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+104},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+108},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+112},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+116},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+120},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+124},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+128},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+132},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+136},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+140},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+144},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+148},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+152},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+156},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+160},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+164},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+168},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+172},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+176},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+180},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+184},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+188},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+192},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+196},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+200},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+204},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+208},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+212},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+216},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+220},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+224},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+228},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+232},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+236},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+240},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+244},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+248},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+252}
        }
        gg.setValues(Nop)
        HookAllAddr = HookAllAddr + 256
    end
    ArmTable[1].address = HookAddr
    ArmTable[2].address = HookAddr + 4
    ArmTable[3].address = HookAddr + 8
    ArmTable[4].address = HookAddr + 12
    gg.setValues(ArmTable)
    CutAddrValue1 = StackAddr + 16 << 48 >> 48
    CutAddrValue2 = StackAddr + 16 << 32 >> 48
    CutAddrValue3 = StackAddr + 16 >> 32
    local CutAddrValue4,CutAddrValue5,CutAddrValue6
    CutAddrValue4 = HookAddr + 16 << 48 >> 48
    CutAddrValue5 = HookAddr + 16 << 32 >> 48
    CutAddrValue6 = HookAddr + 16 >> 32
    local getStackPoint = 30
    local StrRegister = {
        {['value']=-763363296 + CutAddrValue1 * 32 - 544 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3476},
        {['value']=-226492416 + 2097152*1 + CutAddrValue2 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3480},
        {['value']=-226492416 + 2097152*2 + CutAddrValue3 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3484},
        {['value']=-134216704 + Register * 32 + 1 * 0,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3488},--x0
        {['value']=-134216704 + 16777216 + 1024 * 0 + Register * 32 + 1 * 1,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3492},
        {['value']=-134216704 + 16777216 + 1024 * 1 + Register * 32 + 1 * 2,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3496},
        {['value']=-134216704 + 16777216 + 1024 * 2 + Register * 32 + 1 * 3,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3500},
        {['value']=-134216704 + 16777216 + 1024 * 3 + Register * 32 + 1 * 4,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3504},
        {['value']=-134216704 + 16777216 + 1024 * 4 + Register * 32 + 1 * 5,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3508},
        {['value']=-134216704 + 16777216 + 1024 * 5 + Register * 32 + 1 * 6,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3512},
        {['value']=-134216704 + 16777216 + 1024 * 6 + Register * 32 + 1 * 7,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3516},
        {['value']=-134216704 + 16777216 + 1024 * 7 + Register * 32 + 1 * 8,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3520},
        {['value']=-134216704 + 16777216 + 1024 * 8 + Register * 32 + 1 * 9,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3524},
        {['value']=-134216704 + 16777216 + 1024 * 9 + Register * 32 + 1 * 10,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3528},--x10
        {['value']=-134216704 + 16777216 + 1024 * 10 + Register * 32 + 1 * 11,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3532},
        {['value']=-134216704 + 16777216 + 1024 * 11 + Register * 32 + 1 * 12,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3536},
        {['value']=-134216704 + 16777216 + 1024 * 12 + Register * 32 + 1 * 13,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3540},
        {['value']=-134216704 + 16777216 + 1024 * 13 + Register * 32 + 1 * 14,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3544},
        {['value']=-134216704 + 16777216 + 1024 * 14 + Register * 32 + 1 * 15,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3548},
        {['value']=-134216704 + 16777216 + 1024 * 15 + Register * 32 + 1 * 16,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3552},
        {['value']=-134216704 + 16777216 + 1024 * 16 + Register * 32 + 1 * 17,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3556},
        {['value']=-134216704 + 16777216 + 1024 * 17 + Register * 32 + 1 * 18,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3560},
        {['value']=-134216704 + 16777216 + 1024 * 18 + Register * 32 + 1 * 19,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3564},
        {['value']=-134216704 + 16777216 + 1024 * 19 + Register * 32 + 1 * 20,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3568},--x20
        {['value']=-134216704 + 16777216 + 1024 * 20 + Register * 32 + 1 * 21,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3572},
        {['value']=-134216704 + 16777216 + 1024 * 21 + Register * 32 + 1 * 22,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3576},
        {['value']=-134216704 + 16777216 + 1024 * 22 + Register * 32 + 1 * 23,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3580},
        {['value']=-134216704 + 16777216 + 1024 * 23 + Register * 32 + 1 * 24,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3584},
        {['value']=-134216704 + 16777216 + 1024 * 24 + Register * 32 + 1 * 25,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3588},
        {['value']=-134216704 + 16777216 + 1024 * 25 + Register * 32 + 1 * 26,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3592},
        {['value']=-134216704 + 16777216 + 1024 * 26 + Register * 32 + 1 * 27,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3596},
        {['value']=-134216704 + 16777216 + 1024 * 27 + Register * 32 + 1 * 28,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3600},
        {['value']=-134216704 + 16777216 + 1024 * 28 + Register * 32 + 1 * 29,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3604},
        {['value']=-134216704 + 16777216 + 1024 * 29 + Register * 32 + 1 * 30,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3608},--x30
        {['value']=-134216704 + 16777216 + 1024 * 30 + Register * 32 + 1 * 31,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3612},--x31
        {['value']=-1207958528 + 16777216 + 1024 * 62 + Register * 32 + 1 * 0,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3616},--w0
        {['value']=-1207958528 + 16777216 + 1024 * 63 + Register * 32 + 1 * 1,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3620},
        {['value']=-1207958528 + 16777216 + 1024 * 64 + Register * 32 + 1 * 2,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3624},
        {['value']=-1207958528 + 16777216 + 1024 * 65 + Register * 32 + 1 * 3,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3628},
        {['value']=-1207958528 + 16777216 + 1024 * 66 + Register * 32 + 1 * 4,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3632},
        {['value']=-1207958528 + 16777216 + 1024 * 67 + Register * 32 + 1 * 5,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3636},
        {['value']=-1207958528 + 16777216 + 1024 * 68 + Register * 32 + 1 * 6,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3640},
        {['value']=-1207958528 + 16777216 + 1024 * 69 + Register * 32 + 1 * 7,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3644},
        {['value']=-1207958528 + 16777216 + 1024 * 70 + Register * 32 + 1 * 8,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3648},
        {['value']=-1207958528 + 16777216 + 1024 * 71 + Register * 32 + 1 * 9,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3652},
        {['value']=-1207958528 + 16777216 + 1024 * 72 + Register * 32 + 1 * 10,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3656},--w10
        {['value']=-1207958528 + 16777216 + 1024 * 73 + Register * 32 + 1 * 11,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3660},
        {['value']=-1207958528 + 16777216 + 1024 * 74 + Register * 32 + 1 * 12,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3664},
        {['value']=-1207958528 + 16777216 + 1024 * 75 + Register * 32 + 1 * 13,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3668},
        {['value']=-1207958528 + 16777216 + 1024 * 76 + Register * 32 + 1 * 14,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3672},
        {['value']=-1207958528 + 16777216 + 1024 * 77 + Register * 32 + 1 * 15,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3676},
        {['value']=-1207958528 + 16777216 + 1024 * 78 + Register * 32 + 1 * 16,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3680},
        {['value']=-1207958528 + 16777216 + 1024 * 79 + Register * 32 + 1 * 17,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3684},
        {['value']=-1207958528 + 16777216 + 1024 * 80 + Register * 32 + 1 * 18,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3688},
        {['value']=-1207958528 + 16777216 + 1024 * 81 + Register * 32 + 1 * 19,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3692},
        {['value']=-1207958528 + 16777216 + 1024 * 82 + Register * 32 + 1 * 20,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3696},--w20
        {['value']=-1207958528 + 16777216 + 1024 * 83 + Register * 32 + 1 * 21,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3700},
        {['value']=-1207958528 + 16777216 + 1024 * 84 + Register * 32 + 1 * 22,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3704},
        {['value']=-1207958528 + 16777216 + 1024 * 85 + Register * 32 + 1 * 23,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3708},
        {['value']=-1207958528 + 16777216 + 1024 * 86 + Register * 32 + 1 * 24,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3712},
        {['value']=-1207958528 + 16777216 + 1024 * 87 + Register * 32 + 1 * 25,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3716},
        {['value']=-1207958528 + 16777216 + 1024 * 88 + Register * 32 + 1 * 26,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3720},
        {['value']=-1207958528 + 16777216 + 1024 * 89 + Register * 32 + 1 * 27,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3724},
        {['value']=-1207958528 + 16777216 + 1024 * 90 + Register * 32 + 1 * 28,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3728},
        {['value']=-1207958528 + 16777216 + 1024 * 91 + Register * 32 + 1 * 29,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3732},
        {['value']=-1207958528 + 16777216 + 1024 * 92 + Register * 32 + 1 * 30,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3736},--w30
        {['value']=-1207958528 + 16777216 + 1024 * 93 + Register * 32 + 1 * 31,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3740},--w31
        {['value']=-1862269984 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3744},--mov r, sp
        {['value']=-134216704 + 16777216 + 1024 * 47 + Register * 32 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3748},--str r
        {['value']=-763363296 + CutAddrValue4 * 32 - 544 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3752},--mov
        {['value']=-226492416 + 2097152*1 + CutAddrValue5 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3756},
        {['value']=-226492416 + 2097152*2 + CutAddrValue6 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3760},
        {['value']=-134216704 + 16777216 + 512 * 942 + Register * 32 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3764},--str r
        {['value']=335544324,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3768},--b pc + 8
        {['value']=1476395008 + 16777216 - 32 * 2 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3784}--ldr r
    }
    gg.setValues(StrRegister)
    CutAddrValue1 = ArmAddr + 16 << 48 >> 48
    CutAddrValue2 = ArmAddr + 16 << 32 >> 48
    CutAddrValue3 = ArmAddr + 16 >> 32
    local JumpArmMemory = {
        {['value']=-763363296 + CutAddrValue1 * 32 - 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4080},--mov Register #0xnum
        {['value']=-226492416 + 2097152*1 + CutAddrValue2 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4084},--movk Register #0xnum lsl #16
        {['value']=-226492416 + 2097152*2 + CutAddrValue3 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4088},--movk Register #0xnum lsl #32
        {['value']=-702611456 + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4092}--br Register
    }
    gg.setValues(JumpArmMemory)
    CutAddrValue1 = HookAddr << 48 >> 48
    CutAddrValue2 = HookAddr << 32 >> 48
    CutAddrValue3 = HookAddr >> 32
    local JumpHookMemory = {
        {['value']=-763363296 + CutAddrValue1 * 32 - 32 + Register,['flags']=gg.TYPE_DWORD,['address']=ArmAddr},
        {['value']=-226492416 + 2097152*1 + CutAddrValue2 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=ArmAddr+4},
        {['value']=-226492416 + 2097152*2 + CutAddrValue3 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=ArmAddr+8},
        {['value']=-702611456 + Register * 32,['flags']=gg.TYPE_DWORD,['address']=ArmAddr+12}
    }
    gg.setValues(JumpHookMemory)
    table.insert(HookTable['HookAddr'],string.format('%X',HookAddr))
    table.insert(HookTable['StackAddr'],string.format('%X',StackAddr))
    gg.alert('Hook完成\n已添加到保存列表\n你可以在NOP的地方编写指令\n以此来更改其他寄存器的值')
end

function SetHookRegister()
    local ChoiceRegister = 0
    local choice = gg.choice({'X0(默认)','X1','X2','X3','X4','X5','X6','X7','X8','X9','X10','X11','X12','X13','X14','X15','X16','X17','X18','X19','X20','X21','X22','X23','X24','X25','X26','X27','X28','X29'},nil,'请选择寄存器X0~X30\n当前设置的寄存器: X'..ChoiceRegister..'\n选择函数未使用的寄存器，请谨慎选择\n选择了错误的寄存器可能会导致崩溃')
    if choice == nil then gg.alert('你没有选择寄存器') return SetHookRegister() end
    ChoiceRegister = choice - 1
    return ChoiceRegister
end

function JumpFind(ArmAddr)
    local ArmTable = {
        {['flags']=gg.TYPE_DWORD,['address']=ArmAddr},
        {['flags']=gg.TYPE_DWORD,['address']=ArmAddr+4},
        {['flags']=gg.TYPE_DWORD,['address']=ArmAddr+8},
        {['flags']=gg.TYPE_DWORD,['address']=ArmAddr+12}
    }
    ArmTable = gg.getValues(ArmTable)
    for i=1,#ArmTable do
        local Instruction = gg.disasm(gg.ASM_ARM64,ArmTable[i].address,ArmTable[i].value)
        local a = Instruction:match('^(B)')
        if a ~= nil then
            a,b,c,d = Instruction:match('^(B)([A-Z]*)	 (.*)	 ; ([0-9A-F]*) .*')
            if c ~= nil and d ~= nil then
                if i <= 4 then ArmAddr = ArmAddr - (5 - i) * 4
                    return JumpFind(ArmAddr)
                end
            else
                a,b,c = Instruction:match('^(B)([A-Z]*)	 ([A-Z]*[0-9]*)')
                if i <= 4 then ArmAddr = ArmAddr - (5 - i) * 4
                    return JumpFind(ArmAddr)
                end
            end
        end
        a = Instruction:match('^(ADRP)')
        if a ~= nil then
            if i <= 4 then ArmAddr = ArmAddr - (5 - i) * 4 end
            return JumpFind(ArmAddr)
        end
        a = Instruction:match('^(CB)')
        if a ~= nil then
            if i <= 4 then ArmAddr = ArmAddr - (5 - i) * 4 end
            return JumpFind(ArmAddr)
        end
        a = Instruction:match('^(RET)')
        if a ~= nil then
            if i <= 4 then ArmAddr = ArmAddr - (5 - i) * 4 end
            return nil,nil
        end
    end
    return ArmTable,ArmAddr
end
-----------------------------------获取寄存器值------------------------------------
function GetRegisterValue()
    local HookAddr,StackAddr
    local t = {}
    if #HookTable['HookAddr'] == 0 then gg.alert('你没有Hook') return nil end
    choiceHook = gg.choice(HookTable['HookAddr'],nil,'选择Hook')
    if choiceHook == nil then gg.alert('你没有选择Hook') return nil else
        HookAddr = '0x'..HookTable['HookAddr'][choiceHook]
        StackAddr = '0x'..HookTable['StackAddr'][choiceHook]
    end
    local GetRegisterQ = {
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+8},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+16},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+24},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+32},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+40},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+48},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+56},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+64},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+72},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+80},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+88},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+96},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+104},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+112},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+120},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+128},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+136},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+144},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+152},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+160},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+168},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+176},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+184},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+192},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+200},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+208},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+216},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+224},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+232},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+240},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+248},--x31
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+252},--w0
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+256},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+260},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+264},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+268},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+272},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+276},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+280},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+284},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+288},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+292},--w10
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+296},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+300},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+304},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+308},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+312},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+316},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+320},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+324},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+328},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+332},--w20
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+336},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+340},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+344},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+348},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+352},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+356},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+360},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+364},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+368},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+372},
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+376},--w31
        {['flags']=gg.TYPE_QWORD,['address']=StackAddr+384}--sp
    }
    GetRegisterQ = gg.getValues(GetRegisterQ)
    local GetRegisterD = {
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr},--x0
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+8},--x1
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+16},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+24},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+32},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+40},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+48},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+56},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+64},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+72},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+80},--x10
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+88},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+96},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+104},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+112},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+120},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+128},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+136},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+144},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+152},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+160},--x20
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+168},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+176},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+184},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+192},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+200},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+208},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+216},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+224},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+232},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+240},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+248},--x31
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+252},--w0
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+256},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+260},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+264},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+268},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+272},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+276},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+280},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+284},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+288},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+292},--w10
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+296},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+300},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+304},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+308},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+312},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+316},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+320},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+324},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+328},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+332},--w20
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+336},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+340},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+344},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+348},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+352},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+356},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+360},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+364},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+368},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+372},
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+376},--w31
        {['flags']=gg.TYPE_DWORD,['address']=StackAddr+384}--sp
    }
    GetRegisterD = gg.getValues(GetRegisterD)
    for i=1,65 do
        if i < 32 then
            local RegisterValue = 'X'..(i - 1)..': '..GetRegisterD[i].value..'D \n'
            if string.format('%X',GetRegisterQ[i].value):match('^[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]$') ~= nil then RegisterValue = RegisterValue..string.format('%X',GetRegisterQ[i].value)..'h \n' end
            if gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value):match('^	 ; <UNDEFINED>') == nil then RegisterValue = RegisterValue..gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value)..'\n' end
            table.insert(t,RegisterValue)
        elseif i == 32 then
            local RegisterValue = 'XZR: '..GetRegisterD[i].value..'D \n'
            if string.format('%X',GetRegisterQ[i].value):match('^[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]$') ~= nil then RegisterValue = RegisterValue..string.format('%X',GetRegisterQ[i].value)..'h \n' end
            if gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value):match('^	 ; <UNDEFINED>') == nil then RegisterValue = RegisterValue..gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value)..'\n' end
            table.insert(t,RegisterValue)
        elseif i > 32 and i < 64 then
            local RegisterValue = 'W'..(i - 33)..': '..GetRegisterD[i].value..'D \n'
            if string.format('%X',GetRegisterQ[i].value):match('^[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]$') ~= nil then RegisterValue = RegisterValue..string.format('%X',GetRegisterQ[i].value)..'h \n' end
            if gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value):match('^	 ; <UNDEFINED>') == nil then RegisterValue = RegisterValue..gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value)..'\n' end
            table.insert(t,RegisterValue)
        elseif i == 64 then
            local RegisterValue = 'WZR: '..GetRegisterD[i].value..'D \n'
            if string.format('%X',GetRegisterQ[i].value):match('^[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]$') ~= nil then RegisterValue = RegisterValue..string.format('%X',GetRegisterQ[i].value)..'h \n' end
            if gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value):match('^	 ; <UNDEFINED>') == nil then RegisterValue = RegisterValue..gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value)..'\n' end
            table.insert(t,RegisterValue)
            elseif i == 65 then
            local RegisterValue = 'SP: '..GetRegisterD[i].value..'D \n'
            if string.format('%X',GetRegisterQ[i].value):match('^[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]$') ~= nil then RegisterValue = RegisterValue..string.format('%X',GetRegisterQ[i].value)..'h \n' end
            if gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value):match('^	 ; <UNDEFINED>') == nil then RegisterValue = RegisterValue..gg.disasm(gg.ASM_ARM64,GetRegisterD[i].address,GetRegisterD[i].value)..'\n' end
            table.insert(t,RegisterValue)
        end
    end
    if #t == 0 then gg.alert('寄存器值不存在\n可能是你未hook或该函数未调用') return nil end
    local RegistersValues = table.concat(t,'\n')
    local choice = gg.alert(RegistersValues,'保存','查看寄存器','取消')
    if choice == 1 then
        local FileName = '寄存器值 ['..os.date()..'].txt'
        local file = io.open(FileName,'w+')
        for _,v in pairs(t) do 
            file:write(v..'\n')
        end
        file:close()
        gg.alert('文件已保存到'..File..FileName)
        return nil
    elseif choice == 2 then
        choice = gg.choice(t,nil,'查看寄存器')
        if choice == nil then return nil else
            choice1 = gg.choice({'添加到保存列表','跳转到该地址'},nil,t[choice])
            if choice1 == nil then return nil elseif choice1 == 1 then
                gg.addListItems({{['value']=GetRegisterD[choice].value,['flags']=gg.TYPE_DWORD,['address']=GetRegisterD[choice].address}})
            elseif choice1 == 2 then
                gg.gotoAddress(GetRegisterD[choice].address)
                gg.alert('成功跳转到该地址\n去地址列表查看')
            end
        end
    else
        return nil
    end
end
-----------------------------------函数断点------------------------------------
function BreakPoint()
    local HookAddr,StackAddr,getState
    if #HookTable['HookAddr'] == 0 then gg.alert('你没有Hook') return nil end
    choiceHook = gg.choice(HookTable['HookAddr'],nil,'选择Hook')
    if choiceHook == nil then gg.alert('你没有选择Hook') return nil else
        HookAddr = '0x'..HookTable['HookAddr'][choiceHook]
        StackAddr = '0x'..HookTable['StackAddr'][choiceHook]
    end
    local State = {
        {['flags']=gg.TYPE_DWORD,['address']=HookAddr+4060}
    }
    State = gg.getValues(State)
    if State[1].value == 402653183 then
        getState = '断点中'
    elseif State[1].value == -721215457 then
        getState = '未断点'
    else
        getState = '未知状态'
    end
    local B = {
        {['value']=402653183,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4060}
    }
    local NOP = {
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4060}
    }
    if getState == '未断点' then
        choice = gg.choice({'确认断点'},nil,'断点状态: '..getState)
        if choice == nil then return nil else
            gg.setValues(B)
        end
    elseif getState == '断点中' then
        choice = gg.choice({'取消断点'},nil,'断点状态: '..getState)
        if choice == nil then return nil else
            gg.setValues(NOP)
        end
    elseif getState == '未知状态' then
        choice = gg.choice({'确认断点','取消断点'},nil,'断点状态: '..getState)
        if choice == nil then return nil elseif choice == 1 then
            gg.setValues(B)
        elseif choice == 2 then
            gg.setValues(NOP)
        end
    end
end
-----------------------------------改值断点------------------------------------
function findChangeModel_1()
Addr = gg.prompt({"地址(不需要填写0x)"},{},{"number"})
    if Addr == nil then return nil end
    if Addr[1] == "" then gg.alert("你没有输入内容")  return nil
    end
    local b = gg.choice({"A类","D类","F类","E类","W类","B类","Q类","X类"},nil,"选择类型")
    if b == 0 then Arm() end
    if b == 1 then type=5 end
    if b == 2 then type=4 end
    if b == 3 then type=16 end
    if b == 4 then type=64 end
    if b == 5 then type=2 end
    if b == 6 then type=1 end
    if b == 7 then type=32 end
    if b == 8 then type=8 end
    Arma = gg.getValues({{address="0x"..Addr[1],flags=type}})[1].value
    return Arma,Addr,type
end

function findChangeModel_2()
    if next(gg.getSelectedResults()) == nil then gg.alert("你搜索列表没有选择项") return nil end
    Addr = string.format("%x",gg.getSelectedResults()[1].address)
    type = gg.getSelectedListItems()[1].flags
    Arma = gg.getValues({{address="0x"..Addr,flags=type}})[1].value
    return Arma,Addr,type
end

function findChangeModel_3()
if next(gg.getSelectedListItems()) == nil then gg.alert("你保存列表没有选择项") return nil end
    Addr = string.format("%x",gg.getSelectedListItems()[1].address)
    type = gg.getSelectedListItems()[1].flags
    Arma = gg.getValues({{address="0x"..Addr,flags=type}})[1].value
    return Arma,Addr,type
end

function findChange()
    local Addr,type,Arma,Armb,Armlistener,model
    local choice = gg.choice({'输入地址','读取搜索列表选择项','读取保存列表选择项'},nil,'值被改变时暂停进程')
    if choice == nil then return nil end
    if choice == 1 then model = 1 end
    if choice == 2 then model = 2 end
    if choice == 3 then model = 3 end
    if model == nil then return nil end
    if model == 1 then Arma,Addr,type = findChangeModel_1() if Arma == nil then return nil end Armlistener = true end
    if model == 2 then Arma,Addr,type = findChangeModel_2() if Arma == nil then return nil end Armlistener = true end
    if model == 3 then Arma,Addr,type = findChangeModel_3() if Arma == nil then return nil end Armlistener = true end
    show = true
    Armb = Arma
    while Armlistener do
        gg.toast("值未改变")
        if Arma ~= Armb then gg.toast("值被改变了") show = false Armlistener = false
        gg.processPause() end
        if model == 1 then
        Arma = gg.getValues({{address="0x"..Addr[1],flags=type}})[1].value
        else
        Arma = gg.getValues({{address="0x"..Addr,flags=type}})[1].value
        end
    end
end
-----------------------------------缺页检测------------------------------------
function GetMincoreLocal()
    local libc = {}
    local MincoreTable = {}
    local libcTable = gg.getRangesList('lib64/bionic/libc.so')
    if #mincore == 0 then
        if #libcTable == 0 then gg.alert('未找到libc系统库') return nil end
        for i=1,#libcTable do
            if libcTable[i].state == 'Xs' then libc = libcTable[i] break end
        end
        if next(libc) == nil then gg.alert('未找到libc系统内存') return nil end
        local choice = gg.choice({'Hookmincore函数调用','跳转到mincore函数开始地址'},nil,'libc['..string.format('%X',libc.start)..'-'..string.format('%X',libc['end'])..'] 库大小: '..(libc['end'] - libc.start)..'\nmincore函数开始地址: '..string.format('%X',libc.start+0x8E160))
        if choice == nil then return nil end
        if choice == 1 then gg.setRanges(gg.REGION_OTHER) gg.clearResults() gg.searchNumber(libc.start+0x8E160,gg.TYPE_QWORD) end
        if choice == 2 then gg.gotoAddress(libc.start+0x8E160) return nil end
        mincore = gg.getResults(100000,0,nil,nil,libc.start+0x8E160,libc.start+0x8E160)
        if #mincore == 0 then gg.alert('没有发现调用处') return nil end
        gg.alert('发现了'..#mincore..'处调用')
        HookMincoreAddr(mincore)
    else
        HookMincoreAddr(mincore)
    end
end

function HookMincoreAddr(mincore)
    local MincoreTable = {}
    local HookAddr,StackAddr = nil,nil
    if StackAddr == nil or HookAddr == nil then
        HookAddr = gg.allocatePage(gg.PROT_READ | gg.PROT_EXEC | gg.PROT_WRITE)
        StackAddr = gg.allocatePage(gg.PROT_READ | gg.PROT_EXEC | gg.PROT_WRITE)
    end
    for i=1,#mincore do
        table.insert(MincoreTable,string.format('%X',mincore[i].address))
    end
    Register = 29
    choice = gg.choice(MincoreTable,nil,'选择要Hook的函数调用')
    if choice == nil then return nil end
    local MincoreAddr = mincore[choice].address
    HookMincore(Register,MincoreAddr,HookAddr,StackAddr)
end

function HookMincore(Register,MincoreAddr,HookAddr,StackAddr)
    local GetMincorePointer = {
        {['flags']=gg.TYPE_QWORD,['address']=MincoreAddr}
    }
    GetMincorePointer = gg.getValues(GetMincorePointer)
    gg.addListItems({{['flags']=gg.TYPE_DWORD,['address']=StackAddr}})
    gg.addListItems({{['flags']=gg.TYPE_DWORD,['address']=HookAddr}})
    gg.addListItems({{['flags']=gg.TYPE_DWORD,['address']=MincoreAddr}})
    local HookAllAddr = HookAddr
    for i=1,16 do
        local Nop = {
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+4},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+8},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+12},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+16},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+20},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+24},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+28},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+32},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+36},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+40},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+44},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+48},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+52},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+56},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+60},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+64},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+68},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+72},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+76},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+80},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+84},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+88},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+92},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+96},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+100},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+104},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+108},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+112},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+116},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+120},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+124},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+128},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+132},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+136},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+140},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+144},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+148},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+152},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+156},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+160},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+164},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+168},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+172},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+176},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+180},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+184},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+188},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+192},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+196},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+200},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+204},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+208},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+212},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+216},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+220},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+224},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+228},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+232},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+236},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+240},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+244},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+248},
        {['value']=-721215457,['flags']=gg.TYPE_DWORD,['address']=HookAllAddr+252}
        }
        gg.setValues(Nop)
        HookAllAddr = HookAllAddr + 256
    end
    CutAddrValue1 = StackAddr + 16 << 48 >> 48
    CutAddrValue2 = StackAddr + 16 << 32 >> 48
    CutAddrValue3 = StackAddr + 16 >> 32
    local CutAddrValue4,CutAddrValue5,CutAddrValue6
    CutAddrValue4 = HookAddr + 16 << 48 >> 48
    CutAddrValue5 = HookAddr + 16 << 32 >> 48
    CutAddrValue6 = HookAddr + 16 >> 32
    getStackPoint = 30
    local StrRegister = {
        {['value']=335544329,['flags']=gg.TYPE_DWORD,['address']=HookAddr+1996},--b
        {['value']=HookAddr,['flags']=gg.TYPE_QWORD,['address']=HookAddr+2008},--地址
        {['value']=GetMincorePointer[1].value,['flags']=gg.TYPE_QWORD,['address']=HookAddr+2016},--地址
        {['value']=-113254432 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2756},--str x29 sp + 32696
        {['value']=-763363296 + CutAddrValue4 * 32 - 544 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2760},--mov
        {['value']=-226492416 + 2097152*1 + CutAddrValue5 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2764},
        {['value']=-226492416 + 2097152*2 + CutAddrValue6 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2768},
        {['value']=-117180482,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2772},--str x30
        {['value']=-763363296 + CutAddrValue1 * 32 - 544 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2776},
        {['value']=-226492416 + 2097152*1 + CutAddrValue2 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2780},
        {['value']=-226492416 + 2097152*2 + CutAddrValue3 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2784},
        {['value']=-134216704 + Register * 32 + 1 * 0,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2788},--x0
        {['value']=-134216704 + 16777216 + 1024 * 0 + Register * 32 + 1 * 1,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2792},
        {['value']=-134216704 + 16777216 + 1024 * 1 + Register * 32 + 1 * 2,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2796},
        {['value']=-134216704 + 16777216 + 1024 * 2 + Register * 32 + 1 * 3,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2800},
        {['value']=-134216704 + 16777216 + 1024 * 3 + Register * 32 + 1 * 4,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2804},
        {['value']=-134216704 + 16777216 + 1024 * 4 + Register * 32 + 1 * 5,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2808},
        {['value']=-134216704 + 16777216 + 1024 * 5 + Register * 32 + 1 * 6,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2812},
        {['value']=-134216704 + 16777216 + 1024 * 6 + Register * 32 + 1 * 7,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2816},
        {['value']=-134216704 + 16777216 + 1024 * 7 + Register * 32 + 1 * 8,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2820},
        {['value']=-134216704 + 16777216 + 1024 * 8 + Register * 32 + 1 * 9,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2824},
        {['value']=-134216704 + 16777216 + 1024 * 9 + Register * 32 + 1 * 10,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2828},--x10
        {['value']=-134216704 + 16777216 + 1024 * 10 + Register * 32 + 1 * 11,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2832},
        {['value']=-134216704 + 16777216 + 1024 * 11 + Register * 32 + 1 * 12,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2836},
        {['value']=-134216704 + 16777216 + 1024 * 12 + Register * 32 + 1 * 13,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2840},
        {['value']=-134216704 + 16777216 + 1024 * 13 + Register * 32 + 1 * 14,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2844},
        {['value']=-134216704 + 16777216 + 1024 * 14 + Register * 32 + 1 * 15,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2848},
        {['value']=-134216704 + 16777216 + 1024 * 15 + Register * 32 + 1 * 16,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2852},
        {['value']=-134216704 + 16777216 + 1024 * 16 + Register * 32 + 1 * 17,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2856},
        {['value']=-134216704 + 16777216 + 1024 * 17 + Register * 32 + 1 * 18,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2860},
        {['value']=-134216704 + 16777216 + 1024 * 18 + Register * 32 + 1 * 19,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2864},
        {['value']=-134216704 + 16777216 + 1024 * 19 + Register * 32 + 1 * 20,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2868},--x20
        {['value']=-134216704 + 16777216 + 1024 * 20 + Register * 32 + 1 * 21,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2872},
        {['value']=-134216704 + 16777216 + 1024 * 21 + Register * 32 + 1 * 22,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2876},
        {['value']=-134216704 + 16777216 + 1024 * 22 + Register * 32 + 1 * 23,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2880},
        {['value']=-134216704 + 16777216 + 1024 * 23 + Register * 32 + 1 * 24,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2884},
        {['value']=-134216704 + 16777216 + 1024 * 24 + Register * 32 + 1 * 25,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2888},
        {['value']=-134216704 + 16777216 + 1024 * 25 + Register * 32 + 1 * 26,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2892},
        {['value']=-134216704 + 16777216 + 1024 * 26 + Register * 32 + 1 * 27,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2896},
        {['value']=-134216704 + 16777216 + 1024 * 27 + Register * 32 + 1 * 28,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2900},
        {['value']=-134216704 + 16777216 + 1024 * 28 + Register * 32 + 1 * 29,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2904},
        {['value']=-134216704 + 16777216 + 1024 * 29 + Register * 32 + 1 * 30,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2908},--x30
        {['value']=-134216704 + 16777216 + 1024 * 30 + Register * 32 + 1 * 31,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2912},--x31
        {['value']=-1207958528 + 16777216 + 1024 * 62 + Register * 32 + 1 * 0,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2916},--w0
        {['value']=-1207958528 + 16777216 + 1024 * 63 + Register * 32 + 1 * 1,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2920},
        {['value']=-1207958528 + 16777216 + 1024 * 64 + Register * 32 + 1 * 2,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2924},
        {['value']=-1207958528 + 16777216 + 1024 * 65 + Register * 32 + 1 * 3,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2928},
        {['value']=-1207958528 + 16777216 + 1024 * 66 + Register * 32 + 1 * 4,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2932},
        {['value']=-1207958528 + 16777216 + 1024 * 67 + Register * 32 + 1 * 5,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2936},
        {['value']=-1207958528 + 16777216 + 1024 * 68 + Register * 32 + 1 * 6,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2940},
        {['value']=-1207958528 + 16777216 + 1024 * 69 + Register * 32 + 1 * 7,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2944},
        {['value']=-1207958528 + 16777216 + 1024 * 70 + Register * 32 + 1 * 8,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2948},
        {['value']=-1207958528 + 16777216 + 1024 * 71 + Register * 32 + 1 * 9,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2952},
        {['value']=-1207958528 + 16777216 + 1024 * 72 + Register * 32 + 1 * 10,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2956},--w10
        {['value']=-1207958528 + 16777216 + 1024 * 73 + Register * 32 + 1 * 11,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2960},
        {['value']=-1207958528 + 16777216 + 1024 * 74 + Register * 32 + 1 * 12,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2964},
        {['value']=-1207958528 + 16777216 + 1024 * 75 + Register * 32 + 1 * 13,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2968},
        {['value']=-1207958528 + 16777216 + 1024 * 76 + Register * 32 + 1 * 14,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2972},
        {['value']=-1207958528 + 16777216 + 1024 * 77 + Register * 32 + 1 * 15,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2976},
        {['value']=-1207958528 + 16777216 + 1024 * 78 + Register * 32 + 1 * 16,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2980},
        {['value']=-1207958528 + 16777216 + 1024 * 79 + Register * 32 + 1 * 17,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2984},
        {['value']=-1207958528 + 16777216 + 1024 * 80 + Register * 32 + 1 * 18,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2988},
        {['value']=-1207958528 + 16777216 + 1024 * 81 + Register * 32 + 1 * 19,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2992},
        {['value']=-1207958528 + 16777216 + 1024 * 82 + Register * 32 + 1 * 20,['flags']=gg.TYPE_DWORD,['address']=HookAddr+2996},--w20
        {['value']=-1207958528 + 16777216 + 1024 * 83 + Register * 32 + 1 * 21,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3000},
        {['value']=-1207958528 + 16777216 + 1024 * 84 + Register * 32 + 1 * 22,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3004},
        {['value']=-1207958528 + 16777216 + 1024 * 85 + Register * 32 + 1 * 23,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3008},
        {['value']=-1207958528 + 16777216 + 1024 * 86 + Register * 32 + 1 * 24,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3012},
        {['value']=-1207958528 + 16777216 + 1024 * 87 + Register * 32 + 1 * 25,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3016},
        {['value']=-1207958528 + 16777216 + 1024 * 88 + Register * 32 + 1 * 26,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3020},
        {['value']=-1207958528 + 16777216 + 1024 * 89 + Register * 32 + 1 * 27,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3024},
        {['value']=-1207958528 + 16777216 + 1024 * 90 + Register * 32 + 1 * 28,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3028},
        {['value']=-1207958528 + 16777216 + 1024 * 91 + Register * 32 + 1 * 29,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3032},
        {['value']=-1207958528 + 16777216 + 1024 * 92 + Register * 32 + 1 * 30,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3036},--w30
        {['value']=-1207958528 + 16777216 + 1024 * 93 + Register * 32 + 1 * 31,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3040},--w31
        {['value']=-1862269984 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3044},--mov r, sp
        {['value']=-134216704 + 16777216 + 1024 * 47 + Register * 32 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3048},--str r
        {['value']=-763363296 + CutAddrValue4 * 32 - 544 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3052},--mov
        {['value']=-226492416 + 2097152*1 + CutAddrValue5 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3056},
        {['value']=-226492416 + 2097152*2 + CutAddrValue6 * 32 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3060},
        {['value']=-117184512 + Register * 32 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3064},--str r
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3068},--ldr r
        {['value']=-352321505 + 65536 * 0 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3072},--cmp
        {['value']=1409286144 + 32 * 131,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3076},--b.eq--x0
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3080},--ldr r
        {['value']=-352321505 + 65536 * 1 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3084},--cmp
        {['value']=1409286144 + 32 * 132,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3088},--b.eq--x1
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3092},--ldr r
        {['value']=-352321505 + 65536 * 2 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3096},--cmp
        {['value']=1409286144 + 32 * 133,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3100},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3104},--ldr r
        {['value']=-352321505 + 65536 * 3 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3108},--cmp
        {['value']=1409286144 + 32 * 134,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3112},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3116},--ldr r
        {['value']=-352321505 + 65536 * 4 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3120},--cmp
        {['value']=1409286144 + 32 * 135,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3124},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3128},--ldr r
        {['value']=-352321505 + 65536 * 5 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3132},--cmp
        {['value']=1409286144 + 32 * 136,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3136},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3140},--ldr r
        {['value']=-352321505 + 65536 * 6 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3144},--cmp
        {['value']=1409286144 + 32 * 137,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3148},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3152},--ldr r
        {['value']=-352321505 + 65536 * 7 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3156},--cmp
        {['value']=1409286144 + 32 * 138,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3160},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3164},--ldr r
        {['value']=-352321505 + 65536 * 8 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3168},--cmp
        {['value']=1409286144 + 32 * 139,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3172},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3176},--ldr r
        {['value']=-352321505 + 65536 * 9 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3180},--cmp
        {['value']=1409286144 + 32 * 140,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3184},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3188},--ldr r
        {['value']=-352321505 + 65536 * 10 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3192},--cmp
        {['value']=1409286144 + 32 * 141,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3196},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3200},--ldr r
        {['value']=-352321505 + 65536 * 11 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3204},--cmp
        {['value']=1409286144 + 32 * 142,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3208},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3212},--ldr r
        {['value']=-352321505 + 65536 * 12 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3216},--cmp
        {['value']=1409286144 + 32 * 143,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3220},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3224},--ldr r
        {['value']=-352321505 + 65536 * 13 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3228},--cmp
        {['value']=1409286144 + 32 * 144,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3232},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3236},--ldr r
        {['value']=-352321505 + 65536 * 14 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3240},--cmp
        {['value']=1409286144 + 32 * 145,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3244},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3248},--ldr r
        {['value']=-352321505 + 65536 * 15 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3252},--cmp
        {['value']=1409286144 + 32 * 146,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3256},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3260},--ldr r
        {['value']=-352321505 + 65536 * 16 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3264},--cmp
        {['value']=1409286144 + 32 * 147,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3268},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3272},--ldr r
        {['value']=-352321505 + 65536 * 17 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3276},--cmp
        {['value']=1409286144 + 32 * 148,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3280},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3284},--ldr r
        {['value']=-352321505 + 65536 * 18 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3288},--cmp
        {['value']=1409286144 + 32 * 149,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3292},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3296},--ldr r
        {['value']=-352321505 + 65536 * 19 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3300},--cmp
        {['value']=1409286144 + 32 * 150,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3304},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3308},--ldr r
        {['value']=-352321505 + 65536 * 20 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3312},--cmp
        {['value']=1409286144 + 32 * 151,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3316},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3320},--ldr r
        {['value']=-352321505 + 65536 * 21 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3324},--cmp
        {['value']=1409286144 + 32 * 152,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3328},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3332},--ldr r
        {['value']=-352321505 + 65536 * 22 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3336},--cmp
        {['value']=1409286144 + 32 * 153,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3340},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3344},--ldr r
        {['value']=-352321505 + 65536 * 23 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3348},--cmp
        {['value']=1409286144 + 32 * 154,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3352},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3356},--ldr r
        {['value']=-352321505 + 65536 * 24 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3360},--cmp
        {['value']=1409286144 + 32 * 155,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3364},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3368},--ldr r
        {['value']=-352321505 + 65536 * 25 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3372},--cmp
        {['value']=1409286144 + 32 * 156,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3376},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3380},--ldr r
        {['value']=-352321505 + 65536 * 26 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3384},--cmp
        {['value']=1409286144 + 32 * 157,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3388},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3392},--ldr r
        {['value']=-352321505 + 65536 * 27 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3396},--cmp
        {['value']=1409286144 + 32 * 158,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3400},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3404},--ldr r
        {['value']=-352321505 + 65536 * 28 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3408},--cmp
        {['value']=1409286144 + 32 * 159,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3412},--b.eq
        {['value']=-112989184 + getStackPoint + Register * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3416},--ldr r
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3420},--ldr x29 sp + 32696
        {['value']=-352321505 + 65536 * 29 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3424},--cmp
        {['value']=1409286144 + 32 * 159,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3428},--b.eq
        {['value']=1493160990,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3432},--ldr x30 sp + 32688
        {['value']=1493160829,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3436},--ldr x29 pc - 0x594
        {['value']=-352321505 + 65536 * 29 + 32 * getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3440},--cmp
        {['value']=1409286144 + 32 * 159,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3444},--b.eq
        {['value']=1493160830 + getStackPoint,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3448},--ldr x30, pc - 0x594
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3452},--ldr x29 sp + 32696
        {['value']=-698416192,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3456}--ret
    }
    gg.setValues(StrRegister)
    local JumpArmMemory = {
        {['value']=1493159646,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3600},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 0,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3604},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3608},--ldr r sp + 32696
        {['value']=-702611456 + 0 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3612},
        {['value']=1493159646 + -128 * 1,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3616},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 1,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3620},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3624},--ldr r sp + 32696
        {['value']=-702611456 + 1 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3628},
        {['value']=1493159646 + -128 * 2,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3632},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 2,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3636},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3640},--ldr r sp + 32696
        {['value']=-702611456 + 2 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3644},
        {['value']=1493159646 + -128 * 3,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3648},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 3,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3652},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3656},--ldr r sp + 32696
        {['value']=-702611456 + 3 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3660},
        {['value']=1493159646 + -128 * 4,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3664},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 4,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3668},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3672},--ldr r sp + 32696
        {['value']=-702611456 + 4 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3676},
        {['value']=1493159646 + -128 * 5,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3680},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 5,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3684},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3688},--ldr r sp + 32696
        {['value']=-702611456 + 5 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3692},
        {['value']=1493159646 + -128 * 6,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3696},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 6,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3700},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3704},--ldr r sp + 32696
        {['value']=-702611456 + 6 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3708},
        {['value']=1493159646 + -128 * 7,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3712},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 7,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3716},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3720},--ldr r sp + 32696
        {['value']=-702611456 + 7 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3724},
        {['value']=1493159646 + -128 * 8,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3728},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 8,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3732},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3736},--ldr r sp + 32696
        {['value']=-702611456 + 8 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3740},
        {['value']=1493159646 + -128 * 9,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3744},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 9,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3748},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3752},--ldr r sp + 32696
        {['value']=-702611456 + 9 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3756},
        {['value']=1493159646 + -128 * 10,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3760},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 10,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3764},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3768},--ldr r sp + 32696
        {['value']=-702611456 + 10 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3772},
        {['value']=1493159646 + -128 * 11,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3776},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 11,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3780},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3784},--ldr r sp + 32696
        {['value']=-702611456 + 11 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3788},
        {['value']=1493159646 + -128 * 12,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3792},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 12,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3796},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3800},--ldr r sp + 32696
        {['value']=-702611456 + 12 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3804},
        {['value']=1493159646 + -128 * 13,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3808},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 13,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3812},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3816},--ldr r sp + 32696
        {['value']=-702611456 + 13 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3820},
        {['value']=1493159646 + -128 * 14,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3824},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 14,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3828},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3832},--ldr r sp + 32696
        {['value']=-702611456 + 14 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3836},
        {['value']=1493159646 + -128 * 15,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3840},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 15,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3844},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3848},--ldr r sp + 32696
        {['value']=-702611456 + 15 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3852},
        {['value']=1493159646 + -128 * 16,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3856},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 16,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3860},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3864},--ldr r sp + 32696
        {['value']=-702611456 + 16 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3868},
        {['value']=1493159646 + -128 * 17,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3872},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 17,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3876},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3880},--ldr r sp + 32696
        {['value']=-702611456 + 17 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3884},
        {['value']=1493159646 + -128 * 18,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3888},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 18,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3892},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3896},--ldr r sp + 32696
        {['value']=-702611456 + 18 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3900},
        {['value']=1493159646 + -128 * 19,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3904},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 19,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3908},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3912},--ldr r sp + 32696
        {['value']=-702611456 + 19 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3916},
        {['value']=1493159646 + -128 * 20,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3920},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 20,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3924},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3928},--ldr r sp + 32696
        {['value']=-702611456 + 20 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3932},
        {['value']=1493159646 + -128 * 21,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3936},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 21,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3940},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3944},--ldr r sp + 32696
        {['value']=-702611456 + 21 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3948},
        {['value']=1493159646 + -128 * 22,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3952},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 22,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3956},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3960},--ldr r sp + 32696
        {['value']=-702611456 + 22 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3964},
        {['value']=1493159646 + -128 * 23,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3968},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 23,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3972},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3976},--ldr r sp + 32696
        {['value']=-702611456 + 23 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3980},
        {['value']=1493159646 + -128 * 24,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3984},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 24,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3988},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3992},--ldr r sp + 32696
        {['value']=-702611456 + 24 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+3996},
        {['value']=1493159646 + -128 * 25,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4000},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 25,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4004},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4008},--ldr r sp + 32696
        {['value']=-702611456 + 25 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4012},
        {['value']=1493159646 + -128 * 26,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4016},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 26,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4020},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4024},--ldr r sp + 32696
        {['value']=-702611456 + 26 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4028},
        {['value']=1493159646 + -128 * 27,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4032},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 27,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4036},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4040},--ldr r sp + 32696
        {['value']=-702611456 + 27 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4044},
        {['value']=1493159646 + -128 * 28,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4048},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 28,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4052},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4056},--ldr r sp + 32696
        {['value']=-702611456 + 28 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4060},
        {['value']=1493159646 + -128 * 29,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4064},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 29,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4068},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4072},--ldr r sp + 32696
        {['value']=-702611456 + 29 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4076},
        {['value']=1493159646 + -128 * 30,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4080},--ldr r r + 2000
        {['value']=-112988160 + Register * 32 + 30,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4084},--ldr r r + 2016
        {['value']=-109060128 + Register,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4088},--ldr r sp + 32696
        {['value']=-702611456 + 30 * 32,['flags']=gg.TYPE_DWORD,['address']=HookAddr+4092}--br Register
    }
    gg.setValues(JumpArmMemory)
    local JumpHookMemory = {
        {['value']=HookAddr,['flags']=gg.TYPE_QWORD,['address']=MincoreAddr}
    }
    gg.setValues(JumpHookMemory)
    table.insert(HookTable['HookAddr'],string.format('%X',HookAddr))
    table.insert(HookTable['StackAddr'],string.format('%X',StackAddr))
    gg.alert('Hook完成\n已添加到保存列表\n你可以在NOP的地方编写指令\n以此来更改其他寄存器的值')
end
--------------------------------------选择框---------------------------------------

while true do
    gg.showUiButton()
    if gg.isClickedUiButton() then
        local choice = gg.choice({'hook汇编段','获取寄存器值','函数断点','改值断点','缺页检测','Arm64寄存器详细','退出'},nil,name..' ['..x..']\n'..pkg)
        if choice == 7 then os.exit() end
        if choice == 6 then gg.alert('x0~x7：传递子程序的参数和返回值，使用时不需要保存，多余的参数用堆栈传递，64位的返回结果保存在x0中,更多参数用堆栈传递。\nx8：用于保存子程序的返回地址，使用时不需要保存。\nx9~x15：临时寄存器，也叫可变寄存器，子程序使用时不需要保存。\nx16~x17：子程序内部调用寄存器（IPx），使用时不需要保存，尽量不要使用。\nx18：平台寄存器，它的使用与平台相关，尽量不要使用。\nx19~x28：临时寄存器，子程序使用时必须保存。\nx29：帧指针寄存器（FP），用于连接栈帧，使用时必须保存。\nx30：链接寄存器（LR），用于保存子程序的返回地址。\nx31：堆栈指针寄存器（SP），用于指向每个函数的栈顶。\nPC：记录当前CPU当前指令的哪一条指令,存储当前CPU正在执行的指令地址,类似IP\nCPSR寄存器:状态标识寄存器,每一位都存着0或1') end
        if choice == 5 then GetMincoreLocal() end
        if choice == 4 then findChange() end
        if choice == 3 then BreakPoint() end
        if choice == 2 then GetRegisterValue() end
        if choice == 1 then CreatHookMemory() end
    end
end