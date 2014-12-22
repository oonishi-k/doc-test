%module xbyak

%{
#define SWIG_FILE_WITH_INIT
#include "xbyak/xbyak.h"
using namespace Xbyak;
typedef CodeGenerator::LabelType LabelType;
%}

class Operand{
protected:
Operand();
};


class Reg: public Operand{
protected:
Reg();
%pythoncode %{
	def __add__(me, r):
		return _xbyak.Reg__add__(me, r)
	def __sub__(me, r):
		return _xbyak.Reg__sub__(me, r)
%}
};

class Mmx: public Reg{protected:Mmx();};
class Fpu:    public Reg{protected:Fpu();};
class Reg64:  public Reg{protected:Reg64();};
class Reg32:  public Reg{protected:Reg32();};
class Reg16:  public Reg{protected:Reg16();};
class Reg8:   public Reg{protected:Reg8();};
class Xmm:    public Reg{protected:Xmm();};
class Ymm:    public Reg{protected:Ymm();};
class RegRip;

class Label;

class RegExp{
public:
	RegExp(const Reg& r);
%pythoncode %{
	def __add__(me, r):
		return _xbyak.RegExp__add__(me, r)
	def __sub__(me, r):
		return _xbyak.RegExp__sub__(me, r)
%}
};

%rename(RegExp__add__) operator+;
%rename(RegExp__sub__) operator-;
RegExp operator+(const RegExp& left, const RegExp& right) const;
RegExp operator+(const RegExp& left, long long right) const;
RegExp operator-(const RegExp& left, long long right) const;

%rename(Reg__add__) operator+;
%rename(Reg__sub__) operator-;
RegExp operator+(const Reg& left, const Reg& right) const;
RegExp operator+(const Reg& left, long long right) const;
RegExp operator-(const Reg& left, long long right) const;



typedef unsigned int uint32;

typedef unsigned long long uint64;

class Address:    public Operand{protected:Address();};

class AddressFrame{
public:
	%rename(__getitem__) operator[];
	
	//Address operator[](const void *disp) const;
	Address operator[](uint64 disp) const;
	Address operator[](const RegRip& addr) const;
	Address operator[](const RegExp& e) const;
	Address operator[](const Reg&    reg) const;
	
	
	// 暗黙cast用
	//Address operator[](const Reg& e) const;
	
	//%extend {
	//	Address __getitem__(uint64 disp) { return (*this)[disp]; }
	//	Address __getitem__(uint64 disp) { return (*this)[disp]; }
	//	Address __getitem__(uint64 disp) { return (*this)[disp]; }
	//	Address __getitem__(uint64 disp) { return (*this)[disp]; }
	//}
protected:
	AddressFrame();
	
};


%inline %{
size_t createCode(CodeGenerator* code){
	auto x = code->getCode();
	return (size_t)x;
}
%}

%inline %{
/* C-style cast */
const void *const_voidp(uint64 x) {
   return (const void*)x;
}

%}

%typemap(out) void*{
	 $result = PyInt_FromSize_t((size_t)$1);
}
class CodeGenerator{
public:	

	const Mmx mm0, mm1, mm2, mm3, mm4, mm5, mm6, mm7;
	const Xmm xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm6, xmm7;
	const Ymm ymm0, ymm1, ymm2, ymm3, ymm4, ymm5, ymm6, ymm7;
	const Xmm &xm0, &xm1, &xm2, &xm3, &xm4, &xm5, &xm6, &xm7;
	const Ymm &ym0, &ym1, &ym2, &ym3, &ym4, &ym5, &ym6, &ym7;
	const Reg32 eax, ecx, edx, ebx, esp, ebp, esi, edi;
	const Reg16 ax, cx, dx, bx, sp, bp, si, di;
	const Reg8 al, cl, dl, bl, ah, ch, dh, bh;
	const AddressFrame ptr, byte, word, dword, qword;
	const Fpu st0, st1, st2, st3, st4, st5, st6, st7;

	const Reg64 rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14, r15;
	const Reg32 r8d, r9d, r10d, r11d, r12d, r13d, r14d, r15d;
	const Reg16 r8w, r9w, r10w, r11w, r12w, r13w, r14w, r15w;
	const Reg8 r8b, r9b, r10b, r11b, r12b, r13b, r14b, r15b;
	const Reg8 spl, bpl, sil, dil;
	const Xmm xmm8, xmm9, xmm10, xmm11, xmm12, xmm13, xmm14, xmm15;
	const Ymm ymm8, ymm9, ymm10, ymm11, ymm12, ymm13, ymm14, ymm15;
	const Xmm &xm8, &xm9, &xm10, &xm11, &xm12, &xm13, &xm14, &xm15; // for my convenience
	const Ymm &ym8, &ym9, &ym10, &ym11, &ym12, &ym13, &ym14, &ym15;
	const RegRip rip;
	
	size_t getSize() const;
	unsigned int getVersion() const;
	
	void L(const char* label);
	void jmp(const void *addr);
	void jmp(const Operand& op);
	void jmp(const char* label);
	
	void jz(const char* label);
	void jnz(const char* label);
	void jg(const char* label);
	void jge(const char* label);
	void jl(const char* label);
	void jle(const char* label);
	
	void call(const Operand& op);
	
	void call(const void* addr);

	// (REG|MEM, REG)
	void test(const Operand& op, const Reg& reg);	
	// (REG|MEM, IMM)
	void test(const Operand& op, uint32 imm);

	void ret();
	
	void pop(const Operand& op);
	void push(const Operand& op);
	void push(const AddressFrame& af, uint32 imm);
	void push(uint32 imm);
	void bswap(const Reg32e& reg);

	void mov(const Operand& reg1, const Operand& reg2);
	void mov(const Operand& op, unsigned long long imm);
	void* getCode();
	#define XBYAK_NO_OP_NAMES
	#define XBYAK64
	%include "./xbyak/xbyak_mnemonic.h" 
};

namespace util{
static const Mmx mm0, mm1, mm2, mm3, mm4, mm5, mm6, mm7;
static const Xmm xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm6, xmm7;
static const Ymm ymm0, ymm1, ymm2, ymm3, ymm4, ymm5, ymm6, ymm7;
static const Reg32 eax, ecx, edx, ebx, esp, ebp, esi, edi;
static const Reg16 ax, cx, dx, bx, sp, bp, si, di;
static const Reg8 al, cl, dl, bl, ah, ch, dh, bh;
static const AddressFrame ptr, byte, word, dword, qword;
static const Fpu st0, st1, st2, st3, st4, st5, st6, st7;
static const Reg64 rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14, r15;
static const Reg32 r8d, r9d, r10d, r11d, r12d, r13d, r14d, r15d;
static const Reg16 r8w, r9w, r10w, r11w, r12w, r13w, r14w, r15w;
static const Reg8 r8b, r9b, r10b, r11b, r12b, r13b, r14b, r15b, spl, bpl, sil, dil;
static const Xmm xmm8, xmm9, xmm10, xmm11, xmm12, xmm13, xmm14, xmm15;
static const Ymm ymm8, ymm9, ymm10, ymm11, ymm12, ymm13, ymm14, ymm15;
static const RegRip rip;
}