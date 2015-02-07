	.file	"gumptionaire.c"
	.section	.text$_Z6isHitXP4RectP5Point,"x"
	.linkonce discard
	.p2align 4,,15
	.globl	_Z6isHitXP4RectP5Point
	.def	_Z6isHitXP4RectP5Point;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z6isHitXP4RectP5Point
_Z6isHitXP4RectP5Point:
.LFB65:
	.seh_endprologue
	vmovss	5(%rdx), %xmm0
	vcomiss	(%rcx), %xmm0
	jb	.L6
	vcomiss	8(%rcx), %xmm0
	setbe	%al
	ret
	.p2align 4,,10
.L6:
	xorl	%eax, %eax
	ret
	.seh_endproc
	.section	.text$_Z6isHitYP4RectP5Point,"x"
	.linkonce discard
	.p2align 4,,15
	.globl	_Z6isHitYP4RectP5Point
	.def	_Z6isHitYP4RectP5Point;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z6isHitYP4RectP5Point
_Z6isHitYP4RectP5Point:
.LFB66:
	.seh_endprologue
	vmovss	9(%rdx), %xmm0
	vcomiss	4(%rcx), %xmm0
	jb	.L14
	vcomiss	12(%rcx), %xmm0
	setbe	%al
	ret
	.p2align 4,,10
.L14:
	xorl	%eax, %eax
	ret
	.seh_endproc
	.text
	.p2align 4,,15
	.globl	_Z9printRect4Rect
	.def	_Z9printRect4Rect;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9printRect4Rect
_Z9printRect4Rect:
.LFB52:
	.seh_endprologue
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z11printPointsP5Pointi
	.def	_Z11printPointsP5Pointi;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z11printPointsP5Pointi
_Z11printPointsP5Pointi:
.LFB53:
	.seh_endprologue
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z5xsortP5Pointj
	.def	_Z5xsortP5Pointj;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z5xsortP5Pointj
_Z5xsortP5Pointj:
.LFB57:
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$520, %rsp
	.seh_stackalloc	520
	.seh_endprologue
	cmpl	$4, %edx
	ja	.L19
	movl	%edx, %edx
	leaq	(%rdx,%rdx,2), %rax
	leaq	-13(%rdx,%rax,4), %r13
	addq	%rcx, %r13
.L20:
	leaq	52(%rcx), %r8
	leaq	13(%rcx), %r11
	cmpq	%r8, %r13
	cmovbe	%r13, %r8
	cmpq	%r8, %r11
	ja	.L42
	vmovss	5(%rcx), %xmm1
	movq	%r11, %rax
	movq	%rcx, %rdx
	.p2align 4,,10
.L47:
	vmovss	5(%rax), %xmm0
	vcomiss	%xmm0, %xmm1
	vminss	%xmm1, %xmm0, %xmm1
	cmova	%rax, %rdx
	addq	$13, %rax
	cmpq	%r8, %rax
	jbe	.L47
	cmpq	%rcx, %rdx
	je	.L42
	movq	(%rcx), %r9
	movzbl	(%rdx), %r8d
	movl	1(%rdx), %eax
	vmovss	9(%rdx), %xmm0
	movq	%r9, (%rdx)
	movl	8(%rcx), %r9d
	movl	%r9d, 8(%rdx)
	movzbl	12(%rcx), %r9d
	movb	%r9b, 12(%rdx)
	movb	%r8b, (%rcx)
	movl	%eax, 1(%rcx)
	vmovss	%xmm1, 5(%rcx)
	vmovss	%xmm0, 9(%rcx)
.L42:
	movq	%r11, %rax
	leaq	13(%rax), %r10
	cmpq	%r13, %r10
	ja	.L69
	.p2align 4,,10
.L72:
	movq	%r10, %rdx
	subq	%rcx, %rdx
	vmovss	-8(%r11,%rdx), %xmm0
	movq	%rax, %rdx
	vcomiss	-8(%r10), %xmm0
	jb	.L68
	jmp	.L50
	.p2align 4,,10
.L49:
	movq	%r8, %rdx
.L68:
	vcomiss	-8(%rdx), %xmm0
	leaq	-13(%rdx), %r8
	jb	.L49
	cmpq	%rdx, %r10
	je	.L50
	cmpq	%rdx, %rax
	movzbl	(%r10), %esi
	movl	1(%r10), %ebx
	vmovss	9(%r10), %xmm1
	jb	.L60
	movq	%r10, %r8
	jmp	.L52
	.p2align 4,,10
.L71:
	movq	%rax, %r8
	movq	%r9, %rax
.L52:
	movq	(%rax), %r9
	movq	%r9, (%r8)
	movl	8(%rax), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rax), %r9d
	movb	%r9b, 12(%r8)
	leaq	-13(%rax), %r9
	cmpq	%rdx, %r9
	jae	.L71
.L51:
	movb	%sil, (%rax)
	movl	%ebx, 1(%rax)
	vmovss	%xmm0, 5(%rax)
	vmovss	%xmm1, 9(%rax)
.L50:
	movq	%r10, %rax
	leaq	13(%rax), %r10
	cmpq	%r13, %r10
	jbe	.L72
.L69:
	addq	$520, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
.L60:
	movq	%r10, %rax
	jmp	.L51
.L19:
	movl	%edx, %eax
	movq	%rcx, %rbx
	movq	%rsp, %r12
	leaq	(%rax,%rax,2), %rdx
	movabsq	$5675921253449092805, %rbp
	leaq	-13(%rax,%rdx,4), %r13
	leaq	16(%rsp), %rdi
	addq	%rcx, %r13
	movq	%r13, %rsi
.L41:
	movq	%rsi, %rax
	subq	%rbx, %rax
	imulq	%rbp, %rax
	sarq	%rax
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %r8
	addq	%rbx, %r8
	vmovss	5(%r8), %xmm0
	vcomiss	5(%rbx), %xmm0
	jae	.L21
	movq	(%rbx), %r9
	movzbl	(%r8), %edx
	movl	1(%r8), %eax
	vmovss	9(%r8), %xmm1
	movq	%r9, (%r8)
	movl	8(%rbx), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rbx), %r9d
	movb	%r9b, 12(%r8)
	movb	%dl, (%rbx)
	movl	%eax, 1(%rbx)
	vmovss	%xmm0, 5(%rbx)
	vmovss	%xmm1, 9(%rbx)
	vmovss	5(%r8), %xmm0
.L21:
	vcomiss	5(%rsi), %xmm0
	jbe	.L23
	movq	(%rsi), %r9
	movzbl	(%r8), %edx
	movl	1(%r8), %eax
	vmovss	9(%r8), %xmm1
	movq	%r9, (%r8)
	movl	8(%rsi), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rsi), %r9d
	movb	%r9b, 12(%r8)
	movb	%dl, (%rsi)
	movl	%eax, 1(%rsi)
	vmovss	%xmm0, 5(%rsi)
	vmovss	%xmm1, 9(%rsi)
	vmovss	5(%r8), %xmm0
	vcomiss	5(%rbx), %xmm0
	jae	.L23
	movq	(%rbx), %r9
	movzbl	(%r8), %edx
	movl	1(%r8), %eax
	vmovss	9(%r8), %xmm1
	movq	%r9, (%r8)
	movl	8(%rbx), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rbx), %r9d
	movb	%r9b, 12(%r8)
	movb	%dl, (%rbx)
	movl	%eax, 1(%rbx)
	vmovss	%xmm0, 5(%rbx)
	vmovss	%xmm1, 9(%rbx)
	vmovss	5(%r8), %xmm0
.L23:
	leaq	13(%rbx), %rdx
	leaq	-13(%rsi), %rax
	.p2align 4,,10
.L26:
	vmovss	5(%rdx), %xmm1
	vcomiss	%xmm1, %xmm0
	jbe	.L70
.L27:
	addq	$13, %rdx
	vmovss	5(%rdx), %xmm1
	vcomiss	%xmm1, %xmm0
	ja	.L27
	vcomiss	5(%rax), %xmm0
	jae	.L73
	.p2align 4,,10
.L67:
	subq	$13, %rax
.L70:
	vcomiss	5(%rax), %xmm0
	jb	.L67
.L73:
	cmpq	%rax, %rdx
	jae	.L32
	movq	(%rax), %r11
	cmpq	%rdx, %r8
	movzbl	(%rdx), %r10d
	movl	1(%rdx), %r9d
	vmovss	9(%rdx), %xmm0
	movq	%r11, (%rdx)
	movl	8(%rax), %r11d
	movl	%r11d, 8(%rdx)
	movzbl	12(%rax), %r11d
	movb	%r11b, 12(%rdx)
	movb	%r10b, (%rax)
	movl	%r9d, 1(%rax)
	vmovss	%xmm1, 5(%rax)
	vmovss	%xmm0, 9(%rax)
	je	.L56
	cmpq	%rax, %r8
	cmove	%rdx, %r8
.L33:
	addq	$13, %rdx
	subq	$13, %rax
.L34:
	cmpq	%rax, %rdx
	ja	.L35
	vmovss	5(%r8), %xmm0
	jmp	.L26
	.p2align 4,,10
.L32:
	jne	.L34
	addq	$13, %rdx
	subq	$13, %rax
.L35:
	movq	%rax, %r8
	subq	%rbx, %r8
	cmpq	$64, %r8
	jg	.L37
	movq	%rsi, %rax
	movq	%rdx, %rbx
	subq	%rdx, %rax
	cmpq	$64, %rax
	jg	.L38
	movq	-8(%rdi), %rbx
	subq	$16, %rdi
	movq	(%rdi), %rsi
.L38:
	cmpq	%r12, %rdi
	ja	.L41
	jmp	.L20
	.p2align 4,,10
.L56:
	movq	%rax, %r8
	jmp	.L33
.L37:
	movq	%rsi, %r9
	subq	%rdx, %r9
	cmpq	$64, %r9
	jle	.L59
	imulq	%rbp, %r8
	imulq	%rbp, %r9
	cmpq	%r9, %r8
	jle	.L39
	movq	%rbx, 8(%rdi)
	addq	$16, %rdi
	movq	%rdx, %rbx
	movq	%rax, -16(%rdi)
	jmp	.L38
.L59:
	movq	%rax, %rsi
	jmp	.L38
.L39:
	movq	%rsi, (%rdi)
	addq	$16, %rdi
	movq	%rax, %rsi
	movq	%rdx, -8(%rdi)
	jmp	.L38
	.seh_endproc
	.p2align 4,,15
	.globl	_Z5ysortP5Pointj
	.def	_Z5ysortP5Pointj;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z5ysortP5Pointj
_Z5ysortP5Pointj:
.LFB58:
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$520, %rsp
	.seh_stackalloc	520
	.seh_endprologue
	cmpl	$4, %edx
	ja	.L75
	movl	%edx, %edx
	leaq	(%rdx,%rdx,2), %rax
	leaq	-13(%rdx,%rax,4), %r13
	addq	%rcx, %r13
.L76:
	leaq	52(%rcx), %r8
	leaq	13(%rcx), %r11
	cmpq	%r8, %r13
	cmovbe	%r13, %r8
	cmpq	%r8, %r11
	ja	.L98
	vmovss	9(%rcx), %xmm1
	movq	%r11, %rax
	movq	%rcx, %rdx
	.p2align 4,,10
.L103:
	vmovss	9(%rax), %xmm0
	vcomiss	%xmm0, %xmm1
	vminss	%xmm1, %xmm0, %xmm1
	cmova	%rax, %rdx
	addq	$13, %rax
	cmpq	%r8, %rax
	jbe	.L103
	cmpq	%rcx, %rdx
	je	.L98
	movq	(%rcx), %r9
	vmovss	5(%rdx), %xmm0
	movzbl	(%rdx), %r8d
	movl	1(%rdx), %eax
	movq	%r9, (%rdx)
	movl	8(%rcx), %r9d
	movl	%r9d, 8(%rdx)
	movzbl	12(%rcx), %r9d
	movb	%r9b, 12(%rdx)
	movb	%r8b, (%rcx)
	movl	%eax, 1(%rcx)
	vmovss	%xmm0, 5(%rcx)
	vmovss	%xmm1, 9(%rcx)
.L98:
	movq	%r11, %rax
	leaq	13(%rax), %r10
	cmpq	%r13, %r10
	ja	.L125
	.p2align 4,,10
.L128:
	movq	%r10, %rdx
	subq	%rcx, %rdx
	vmovss	-4(%r11,%rdx), %xmm0
	movq	%rax, %rdx
	vcomiss	-4(%r10), %xmm0
	jb	.L124
	jmp	.L106
	.p2align 4,,10
.L105:
	movq	%r8, %rdx
.L124:
	vcomiss	-4(%rdx), %xmm0
	leaq	-13(%rdx), %r8
	jb	.L105
	cmpq	%rdx, %r10
	je	.L106
	cmpq	%rdx, %rax
	movzbl	(%r10), %esi
	movl	1(%r10), %ebx
	vmovss	5(%r10), %xmm1
	jb	.L116
	movq	%r10, %r8
	jmp	.L108
	.p2align 4,,10
.L127:
	movq	%rax, %r8
	movq	%r9, %rax
.L108:
	movq	(%rax), %r9
	movq	%r9, (%r8)
	movl	8(%rax), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rax), %r9d
	movb	%r9b, 12(%r8)
	leaq	-13(%rax), %r9
	cmpq	%rdx, %r9
	jae	.L127
.L107:
	movb	%sil, (%rax)
	movl	%ebx, 1(%rax)
	vmovss	%xmm1, 5(%rax)
	vmovss	%xmm0, 9(%rax)
.L106:
	movq	%r10, %rax
	leaq	13(%rax), %r10
	cmpq	%r13, %r10
	jbe	.L128
.L125:
	addq	$520, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
.L116:
	movq	%r10, %rax
	jmp	.L107
.L75:
	movl	%edx, %eax
	movq	%rcx, %rbx
	movq	%rsp, %r12
	leaq	(%rax,%rax,2), %rdx
	movabsq	$5675921253449092805, %rbp
	leaq	-13(%rax,%rdx,4), %r13
	leaq	16(%rsp), %rdi
	addq	%rcx, %r13
	movq	%r13, %rsi
.L97:
	movq	%rsi, %rax
	subq	%rbx, %rax
	imulq	%rbp, %rax
	sarq	%rax
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %r8
	addq	%rbx, %r8
	vmovss	9(%r8), %xmm0
	vcomiss	9(%rbx), %xmm0
	jae	.L77
	movq	(%rbx), %r9
	vmovss	5(%r8), %xmm1
	movzbl	(%r8), %edx
	movl	1(%r8), %eax
	movq	%r9, (%r8)
	movl	8(%rbx), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rbx), %r9d
	movb	%r9b, 12(%r8)
	movb	%dl, (%rbx)
	movl	%eax, 1(%rbx)
	vmovss	%xmm1, 5(%rbx)
	vmovss	%xmm0, 9(%rbx)
	vmovss	9(%r8), %xmm0
.L77:
	vcomiss	9(%rsi), %xmm0
	jbe	.L79
	movq	(%rsi), %r9
	vmovss	5(%r8), %xmm1
	movzbl	(%r8), %edx
	movl	1(%r8), %eax
	movq	%r9, (%r8)
	movl	8(%rsi), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rsi), %r9d
	movb	%r9b, 12(%r8)
	movb	%dl, (%rsi)
	movl	%eax, 1(%rsi)
	vmovss	%xmm1, 5(%rsi)
	vmovss	%xmm0, 9(%rsi)
	vmovss	9(%r8), %xmm0
	vcomiss	9(%rbx), %xmm0
	jae	.L79
	movq	(%rbx), %r9
	vmovss	5(%r8), %xmm1
	movzbl	(%r8), %edx
	movl	1(%r8), %eax
	movq	%r9, (%r8)
	movl	8(%rbx), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rbx), %r9d
	movb	%r9b, 12(%r8)
	movb	%dl, (%rbx)
	movl	%eax, 1(%rbx)
	vmovss	%xmm1, 5(%rbx)
	vmovss	%xmm0, 9(%rbx)
	vmovss	9(%r8), %xmm0
.L79:
	leaq	13(%rbx), %rdx
	leaq	-13(%rsi), %rax
	.p2align 4,,10
.L82:
	vmovss	9(%rdx), %xmm1
	vcomiss	%xmm1, %xmm0
	jbe	.L126
.L83:
	addq	$13, %rdx
	vmovss	9(%rdx), %xmm1
	vcomiss	%xmm1, %xmm0
	ja	.L83
	vcomiss	9(%rax), %xmm0
	jae	.L129
	.p2align 4,,10
.L123:
	subq	$13, %rax
.L126:
	vcomiss	9(%rax), %xmm0
	jb	.L123
.L129:
	cmpq	%rax, %rdx
	jae	.L88
	movq	(%rax), %r11
	cmpq	%rdx, %r8
	vmovss	5(%rdx), %xmm0
	movzbl	(%rdx), %r10d
	movl	1(%rdx), %r9d
	movq	%r11, (%rdx)
	movl	8(%rax), %r11d
	movl	%r11d, 8(%rdx)
	movzbl	12(%rax), %r11d
	movb	%r11b, 12(%rdx)
	movb	%r10b, (%rax)
	movl	%r9d, 1(%rax)
	vmovss	%xmm0, 5(%rax)
	vmovss	%xmm1, 9(%rax)
	je	.L112
	cmpq	%rax, %r8
	cmove	%rdx, %r8
.L89:
	addq	$13, %rdx
	subq	$13, %rax
.L90:
	cmpq	%rax, %rdx
	ja	.L91
	vmovss	9(%r8), %xmm0
	jmp	.L82
	.p2align 4,,10
.L88:
	jne	.L90
	addq	$13, %rdx
	subq	$13, %rax
.L91:
	movq	%rax, %r8
	subq	%rbx, %r8
	cmpq	$64, %r8
	jg	.L93
	movq	%rsi, %rax
	movq	%rdx, %rbx
	subq	%rdx, %rax
	cmpq	$64, %rax
	jg	.L94
	movq	-8(%rdi), %rbx
	subq	$16, %rdi
	movq	(%rdi), %rsi
.L94:
	cmpq	%r12, %rdi
	ja	.L97
	jmp	.L76
	.p2align 4,,10
.L112:
	movq	%rax, %r8
	jmp	.L89
.L93:
	movq	%rsi, %r9
	subq	%rdx, %r9
	cmpq	$64, %r9
	jle	.L115
	imulq	%rbp, %r8
	imulq	%rbp, %r9
	cmpq	%r9, %r8
	jle	.L95
	movq	%rbx, 8(%rdi)
	addq	$16, %rdi
	movq	%rdx, %rbx
	movq	%rax, -16(%rdi)
	jmp	.L94
.L115:
	movq	%rax, %rsi
	jmp	.L94
.L95:
	movq	%rsi, (%rdi)
	addq	$16, %rdi
	movq	%rax, %rsi
	movq	%rdx, -8(%rdi)
	jmp	.L94
	.seh_endproc
	.p2align 4,,15
	.globl	_Z8ranksortP5Pointj
	.def	_Z8ranksortP5Pointj;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8ranksortP5Pointj
_Z8ranksortP5Pointj:
.LFB59:
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$520, %rsp
	.seh_stackalloc	520
	.seh_endprologue
	cmpl	$4, %edx
	ja	.L131
	movl	%edx, %edx
	leaq	(%rdx,%rdx,2), %rax
	leaq	-13(%rdx,%rax,4), %r13
	addq	%rcx, %r13
.L132:
	leaq	52(%rcx), %r10
	leaq	13(%rcx), %rbx
	cmpq	%r10, %r13
	cmovbe	%r13, %r10
	cmpq	%r10, %rbx
	ja	.L149
	movl	1(%rcx), %r8d
	movq	%rbx, %rax
	movq	%rcx, %r9
	.p2align 4,,10
.L151:
	movl	1(%rax), %edx
	cmpl	%r8d, %edx
	cmovl	%rax, %r9
	cmovle	%edx, %r8d
	addq	$13, %rax
	cmpq	%r10, %rax
	jbe	.L151
	cmpq	%rcx, %r9
	je	.L149
	movq	(%rcx), %rdx
	vmovss	5(%r9), %xmm1
	movzbl	(%r9), %eax
	vmovss	9(%r9), %xmm0
	movq	%rdx, (%r9)
	movl	8(%rcx), %edx
	movl	%edx, 8(%r9)
	movzbl	12(%rcx), %edx
	movb	%dl, 12(%r9)
	movb	%al, (%rcx)
	movl	%r8d, 1(%rcx)
	vmovss	%xmm1, 5(%rcx)
	vmovss	%xmm0, 9(%rcx)
.L149:
	movq	%rbx, %rax
	leaq	13(%rax), %r11
	cmpq	%r13, %r11
	ja	.L166
	.p2align 4,,10
.L169:
	movq	%r11, %rdx
	subq	%rcx, %rdx
	movl	-12(%rbx,%rdx), %r10d
	cmpl	%r10d, -12(%r11)
	jle	.L154
	movq	%rax, %rdx
	jmp	.L158
	.p2align 4,,10
.L153:
	movq	%r8, %rdx
.L158:
	cmpl	%r10d, -12(%rdx)
	leaq	-13(%rdx), %r8
	jg	.L153
	cmpq	%rdx, %r11
	je	.L154
	cmpq	%rdx, %rax
	movzbl	(%r11), %esi
	vmovss	5(%r11), %xmm1
	vmovss	9(%r11), %xmm0
	jb	.L165
	movq	%r11, %r8
	jmp	.L156
	.p2align 4,,10
.L168:
	movq	%rax, %r8
	movq	%r9, %rax
.L156:
	movq	(%rax), %r9
	movq	%r9, (%r8)
	movl	8(%rax), %r9d
	movl	%r9d, 8(%r8)
	movzbl	12(%rax), %r9d
	movb	%r9b, 12(%r8)
	leaq	-13(%rax), %r9
	cmpq	%rdx, %r9
	jae	.L168
.L155:
	movb	%sil, (%rax)
	movl	%r10d, 1(%rax)
	vmovss	%xmm1, 5(%rax)
	vmovss	%xmm0, 9(%rax)
.L154:
	movq	%r11, %rax
	leaq	13(%rax), %r11
	cmpq	%r13, %r11
	jbe	.L169
.L166:
	addq	$520, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
.L165:
	movq	%r11, %rax
	jmp	.L155
.L131:
	movl	%edx, %eax
	movq	%rcx, %rbx
	movq	%rsp, %r12
	leaq	(%rax,%rax,2), %rdx
	movabsq	$5675921253449092805, %rbp
	leaq	-13(%rax,%rdx,4), %r13
	leaq	16(%rsp), %rdi
	addq	%rcx, %r13
	movq	%r13, %rsi
.L148:
	movq	%rsi, %rax
	subq	%rbx, %rax
	imulq	%rbp, %rax
	sarq	%rax
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %r10
	addq	%rbx, %r10
	movl	1(%r10), %edx
	cmpl	1(%rbx), %edx
	jge	.L133
	movq	(%rbx), %r8
	vmovss	5(%r10), %xmm1
	movzbl	(%r10), %eax
	vmovss	9(%r10), %xmm0
	movq	%r8, (%r10)
	movl	8(%rbx), %r8d
	movl	%r8d, 8(%r10)
	movzbl	12(%rbx), %r8d
	movb	%r8b, 12(%r10)
	movb	%al, (%rbx)
	movl	%edx, 1(%rbx)
	vmovss	%xmm1, 5(%rbx)
	vmovss	%xmm0, 9(%rbx)
	movl	1(%r10), %edx
.L133:
	cmpl	%edx, 1(%rsi)
	jge	.L134
	movq	(%rsi), %r8
	vmovss	5(%r10), %xmm1
	movzbl	(%r10), %eax
	vmovss	9(%r10), %xmm0
	movq	%r8, (%r10)
	movl	8(%rsi), %r8d
	movl	%r8d, 8(%r10)
	movzbl	12(%rsi), %r8d
	movb	%r8b, 12(%r10)
	movb	%al, (%rsi)
	movl	%edx, 1(%rsi)
	vmovss	%xmm1, 5(%rsi)
	vmovss	%xmm0, 9(%rsi)
	movl	1(%r10), %edx
	cmpl	1(%rbx), %edx
	jge	.L134
	movq	(%rbx), %r8
	vmovss	5(%r10), %xmm1
	movzbl	(%r10), %eax
	vmovss	9(%r10), %xmm0
	movq	%r8, (%r10)
	movl	8(%rbx), %r8d
	movl	%r8d, 8(%r10)
	movzbl	12(%rbx), %r8d
	movb	%r8b, 12(%r10)
	movb	%al, (%rbx)
	movl	%edx, 1(%rbx)
	vmovss	%xmm1, 5(%rbx)
	vmovss	%xmm0, 9(%rbx)
	movl	1(%r10), %edx
.L134:
	leaq	13(%rbx), %r8
	leaq	-13(%rsi), %rax
	.p2align 4,,10
.L135:
	movl	1(%r8), %r9d
	cmpl	%edx, %r9d
	jge	.L167
.L136:
	addq	$13, %r8
	movl	1(%r8), %r9d
	cmpl	%edx, %r9d
	jl	.L136
	cmpl	%edx, 1(%rax)
	jle	.L170
	.p2align 4,,10
.L138:
	subq	$13, %rax
.L167:
	cmpl	%edx, 1(%rax)
	jg	.L138
.L170:
	cmpq	%rax, %r8
	jae	.L139
	movq	(%rax), %r11
	cmpq	%r8, %r10
	vmovss	5(%r8), %xmm1
	movzbl	(%r8), %edx
	vmovss	9(%r8), %xmm0
	movq	%r11, (%r8)
	movl	8(%rax), %r11d
	movl	%r11d, 8(%r8)
	movzbl	12(%rax), %r11d
	movb	%r11b, 12(%r8)
	movb	%dl, (%rax)
	movl	%r9d, 1(%rax)
	vmovss	%xmm1, 5(%rax)
	vmovss	%xmm0, 9(%rax)
	je	.L161
	cmpq	%rax, %r10
	cmove	%r8, %r10
.L140:
	addq	$13, %r8
	subq	$13, %rax
.L141:
	cmpq	%rax, %r8
	ja	.L142
	movl	1(%r10), %edx
	jmp	.L135
	.p2align 4,,10
.L139:
	jne	.L141
	addq	$13, %r8
	subq	$13, %rax
.L142:
	movq	%rax, %rdx
	subq	%rbx, %rdx
	cmpq	$64, %rdx
	jg	.L144
	movq	%rsi, %rax
	movq	%r8, %rbx
	subq	%r8, %rax
	cmpq	$64, %rax
	jg	.L145
	movq	-8(%rdi), %rbx
	subq	$16, %rdi
	movq	(%rdi), %rsi
.L145:
	cmpq	%r12, %rdi
	ja	.L148
	jmp	.L132
	.p2align 4,,10
.L161:
	movq	%rax, %r10
	jmp	.L140
.L144:
	movq	%rsi, %r9
	subq	%r8, %r9
	cmpq	$64, %r9
	jle	.L164
	imulq	%rbp, %rdx
	imulq	%rbp, %r9
	cmpq	%r9, %rdx
	jle	.L146
	movq	%rbx, 8(%rdi)
	addq	$16, %rdi
	movq	%r8, %rbx
	movq	%rax, -16(%rdi)
	jmp	.L145
.L164:
	movq	%rax, %rsi
	jmp	.L145
.L146:
	movq	%rsi, (%rdi)
	addq	$16, %rdi
	movq	%rax, %rsi
	movq	%r8, -8(%rdi)
	jmp	.L145
	.seh_endproc
	.p2align 4,,15
	.globl	_Z8bsearchxP5Pointbfii
	.def	_Z8bsearchxP5Pointbfii;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8bsearchxP5Pointbfii
_Z8bsearchxP5Pointbfii:
.LFB67:
	.seh_endprologue
	movl	40(%rsp), %r10d
	cmpl	%r10d, %r9d
	jle	.L187
	jmp	.L172
	.p2align 4,,10
.L209:
	leal	1(%rax), %r9d
	cmpl	%r9d, %r10d
	jl	.L172
.L187:
	leal	(%r10,%r9), %eax
	movl	%eax, %r8d
	shrl	$31, %r8d
	addl	%r8d, %eax
	sarl	%eax
	movslq	%eax, %r8
	leaq	(%r8,%r8,2), %r11
	leaq	(%r8,%r11,4), %r11
	vmovss	5(%rcx,%r11), %xmm0
	vcomiss	%xmm2, %xmm0
	je	.L208
	vcomiss	%xmm0, %xmm2
	ja	.L209
	leal	-1(%rax), %r10d
	cmpl	%r9d, %r10d
	jge	.L187
.L172:
	testb	%dl, %dl
	movl	%r9d, %eax
	cmove	%r10d, %eax
.L206:
	rep ret
	.p2align 4,,10
.L208:
	testb	%dl, %dl
	jne	.L176
	cmpl	%eax, %r10d
	jle	.L206
	addq	$1, %r8
	leaq	(%r8,%r8,2), %rdx
	leaq	(%r8,%rdx,4), %rdx
	vmovss	5(%rcx,%rdx), %xmm0
	vcomiss	%xmm2, %xmm0
	jne	.L210
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r8
	leaq	26(%rdx,%r8,4), %rdx
	leaq	5(%rcx,%rdx), %rdx
	jmp	.L183
	.p2align 4,,10
.L212:
	addq	$13, %rdx
	vcomiss	-13(%rdx), %xmm0
	jne	.L211
.L183:
	addl	$1, %eax
	cmpl	%r10d, %eax
	jne	.L212
	jmp	.L206
	.p2align 4,,10
.L176:
	cmpl	%eax, %r9d
	jge	.L206
	vmovss	-8(%rcx,%r11), %xmm0
	vcomiss	%xmm2, %xmm0
	jne	.L206
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r8
	leaq	-26(%rdx,%r8,4), %rdx
	leaq	5(%rcx,%rdx), %rdx
	jmp	.L181
	.p2align 4,,10
.L214:
	subq	$13, %rdx
	vcomiss	13(%rdx), %xmm0
	jne	.L213
.L181:
	subl	$1, %eax
	cmpl	%r9d, %eax
	jne	.L214
	jmp	.L206
	.p2align 4,,10
.L211:
	rep ret
	.p2align 4,,10
.L213:
	.p2align 4,,11
	rep ret
.L210:
	.p2align 4,,11
	rep ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z8bsearchyP5Pointbfii
	.def	_Z8bsearchyP5Pointbfii;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8bsearchyP5Pointbfii
_Z8bsearchyP5Pointbfii:
.LFB68:
	.seh_endprologue
	movl	40(%rsp), %r10d
	cmpl	%r10d, %r9d
	jle	.L231
	jmp	.L216
	.p2align 4,,10
.L253:
	leal	1(%rax), %r9d
	cmpl	%r9d, %r10d
	jl	.L216
.L231:
	leal	(%r10,%r9), %eax
	movl	%eax, %r8d
	shrl	$31, %r8d
	addl	%r8d, %eax
	sarl	%eax
	movslq	%eax, %r8
	leaq	(%r8,%r8,2), %r11
	leaq	(%r8,%r11,4), %r11
	vmovss	9(%rcx,%r11), %xmm0
	vcomiss	%xmm2, %xmm0
	je	.L252
	vcomiss	%xmm0, %xmm2
	ja	.L253
	leal	-1(%rax), %r10d
	cmpl	%r9d, %r10d
	jge	.L231
.L216:
	testb	%dl, %dl
	movl	%r9d, %eax
	cmove	%r10d, %eax
.L250:
	rep ret
	.p2align 4,,10
.L252:
	testb	%dl, %dl
	jne	.L220
	cmpl	%eax, %r10d
	jle	.L250
	addq	$1, %r8
	leaq	(%r8,%r8,2), %rdx
	leaq	(%r8,%rdx,4), %rdx
	vmovss	9(%rcx,%rdx), %xmm0
	vcomiss	%xmm2, %xmm0
	jne	.L254
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r8
	leaq	26(%rdx,%r8,4), %rdx
	leaq	9(%rcx,%rdx), %rdx
	jmp	.L227
	.p2align 4,,10
.L256:
	addq	$13, %rdx
	vcomiss	-13(%rdx), %xmm0
	jne	.L255
.L227:
	addl	$1, %eax
	cmpl	%r10d, %eax
	jne	.L256
	jmp	.L250
	.p2align 4,,10
.L220:
	cmpl	%eax, %r9d
	jge	.L250
	vmovss	-4(%rcx,%r11), %xmm0
	vcomiss	%xmm2, %xmm0
	jne	.L250
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r8
	leaq	-26(%rdx,%r8,4), %rdx
	leaq	9(%rcx,%rdx), %rdx
	jmp	.L225
	.p2align 4,,10
.L258:
	subq	$13, %rdx
	vcomiss	13(%rdx), %xmm0
	jne	.L257
.L225:
	subl	$1, %eax
	cmpl	%r9d, %eax
	jne	.L258
	jmp	.L250
	.p2align 4,,10
.L255:
	rep ret
	.p2align 4,,10
.L257:
	.p2align 4,,11
	rep ret
.L254:
	.p2align 4,,11
	rep ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z10bvalsearchPfbfii
	.def	_Z10bvalsearchPfbfii;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10bvalsearchPfbfii
_Z10bvalsearchPfbfii:
.LFB69:
	.seh_endprologue
	movl	40(%rsp), %r8d
	cmpl	%r8d, %r9d
	jle	.L275
	jmp	.L260
	.p2align 4,,10
.L297:
	leal	1(%rax), %r9d
	cmpl	%r9d, %r8d
	jl	.L260
.L275:
	leal	(%r8,%r9), %eax
	movl	%eax, %r10d
	shrl	$31, %r10d
	addl	%r10d, %eax
	sarl	%eax
	movslq	%eax, %r10
	vmovss	(%rcx,%r10,4), %xmm0
	leaq	0(,%r10,4), %r11
	vcomiss	%xmm2, %xmm0
	je	.L296
	vcomiss	%xmm0, %xmm2
	ja	.L297
	leal	-1(%rax), %r8d
	cmpl	%r9d, %r8d
	jge	.L275
.L260:
	testb	%dl, %dl
	movl	%r9d, %eax
	cmove	%r8d, %eax
.L294:
	rep ret
	.p2align 4,,10
.L296:
	testb	%dl, %dl
	jne	.L264
	cmpl	%eax, %r8d
	jle	.L294
	vmovss	4(%rcx,%r10,4), %xmm0
	movslq	%eax, %rdx
	leaq	8(%rcx,%rdx,4), %rdx
	vcomiss	%xmm2, %xmm0
	je	.L271
	jmp	.L303
	.p2align 4,,10
.L300:
	addq	$4, %rdx
	vcomiss	-4(%rdx), %xmm0
	jne	.L299
.L271:
	addl	$1, %eax
	cmpl	%r8d, %eax
	jne	.L300
	jmp	.L294
	.p2align 4,,10
.L264:
	cmpl	%eax, %r9d
	jge	.L294
	vmovss	-4(%rcx,%r11), %xmm0
	movslq	%eax, %rdx
	leaq	-8(%rcx,%rdx,4), %rdx
	vcomiss	%xmm2, %xmm0
	je	.L269
	jmp	.L294
	.p2align 4,,10
.L302:
	subq	$4, %rdx
	vcomiss	4(%rdx), %xmm0
	jne	.L301
.L269:
	subl	$1, %eax
	cmpl	%r9d, %eax
	jne	.L302
	jmp	.L294
	.p2align 4,,10
.L299:
	rep ret
	.p2align 4,,10
.L301:
	.p2align 4,,11
	rep ret
.L303:
	.p2align 4,,11
	rep ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z9findHitsUP4RectP5PointiS2_iPFbS0_S2_E
	.def	_Z9findHitsUP4RectP5PointiS2_iPFbS0_S2_E;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9findHitsUP4RectP5PointiS2_iPFbS0_S2_E
_Z9findHitsUP4RectP5PointiS2_iPFbS0_S2_E:
.LFB70:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	cmpl	192(%rsp), %r8d
	movq	%rcx, 32(%rsp)
	movl	%r8d, %edi
	movq	%rdx, 48(%rsp)
	movq	200(%rsp), %r12
	movq	%r9, 40(%rsp)
	jle	.L305
	movl	192(%rsp), %eax
	testl	%eax, %eax
	setg	%al
	testl	%r8d, %r8d
	movb	%al, 59(%rsp)
	jle	.L328
	testb	%al, %al
	je	.L328
	movq	48(%rsp), %r15
	leaq	64(%rsp), %r13
	xorl	%ebx, %ebx
	xorl	%r14d, %r14d
	movq	%r13, %rax
	movl	$-1, %esi
	movl	%ebx, %r13d
	movl	%esi, %ebp
	movq	%rax, %rbx
	movq	%r15, %rcx
	movl	%r14d, %r15d
	movq	%rcx, %r14
	jmp	.L314
	.p2align 4,,10
.L350:
	movl	%ebp, %eax
.L312:
	addl	$1, %r13d
	movl	%eax, %ebp
.L311:
	addl	$1, %r15d
	addq	$13, %r14
	cmpl	%r13d, 192(%rsp)
	jle	.L313
	cmpl	%r15d, %edi
	jle	.L313
.L314:
	movq	(%r14), %rax
	movq	%rbx, %rdx
	movq	32(%rsp), %rcx
	movq	%rax, 64(%rsp)
	movl	8(%r14), %eax
	movl	%eax, 72(%rsp)
	movzbl	12(%r14), %eax
	movb	%al, 76(%rsp)
	call	*%r12
	testb	%al, %al
	je	.L311
	movslq	%r13d, %rax
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %rax
	movq	64(%rsp), %rdx
	addq	40(%rsp), %rax
	movq	%rdx, (%rax)
	movl	72(%rsp), %edx
	movl	%edx, 8(%rax)
	movzbl	76(%rsp), %edx
	movb	%dl, 12(%rax)
	movl	65(%rsp), %eax
	cmpl	%ebp, %eax
	jle	.L350
	movl	%r13d, %esi
	jmp	.L312
	.p2align 4,,10
.L305:
	xorl	%edx, %edx
	xorl	%ebx, %ebx
	testl	%r8d, %r8d
	jle	.L310
	subl	$1, %edi
	movq	48(%rsp), %r15
	xorl	%ebx, %ebx
	leaq	(%rdi,%rdi,2), %rax
	movq	40(%rsp), %rbp
	leaq	(%rdi,%rax,4), %rax
	movq	32(%rsp), %rdi
	leaq	64(%rsp), %r13
	leaq	13(%r15,%rax), %rsi
	.p2align 4,,10
.L325:
	movq	(%r15), %rax
	movq	%r13, %rdx
	movq	%rdi, %rcx
	movq	%rax, 64(%rsp)
	movl	8(%r15), %eax
	movl	%eax, 72(%rsp)
	movzbl	12(%r15), %eax
	movb	%al, 76(%rsp)
	call	*%r12
	testb	%al, %al
	je	.L323
	movslq	%ebx, %rax
	addl	$1, %ebx
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %rax
	movq	64(%rsp), %rdx
	addq	%rbp, %rax
	movq	%rdx, (%rax)
	movl	72(%rsp), %edx
	movl	%edx, 8(%rax)
	movzbl	76(%rsp), %edx
	movb	%dl, 12(%rax)
.L323:
	addq	$13, %r15
	cmpq	%rsi, %r15
	jne	.L325
	movl	%ebx, %edx
.L310:
	movq	40(%rsp), %rcx
	call	_Z8ranksortP5Pointj
.L348:
	movl	%ebx, %eax
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
.L313:
	movl	%r13d, %ebx
	movl	%r15d, %r14d
	movl	%r13d, 60(%rsp)
.L308:
	cmpl	%r14d, %edi
	jle	.L321
	movq	48(%rsp), %r15
	leal	1(%r14), %r13d
	movslq	%r14d, %rax
	leaq	(%rax,%rax,2), %rdx
	movl	192(%rsp), %r14d
	leaq	(%rax,%rdx,4), %rax
	addq	%rax, %r15
	leaq	64(%rsp), %rax
	movq	%rax, 48(%rsp)
	movl	%edi, %eax
	movl	%r13d, %edi
	movl	%esi, %r13d
	movl	%eax, %esi
	jmp	.L322
	.p2align 4,,10
.L319:
	movl	%edi, %eax
	addq	$13, %r15
	addl	$1, %edi
	cmpl	%eax, %esi
	jle	.L321
.L322:
	movq	(%r15), %rax
	movq	%rax, %rcx
	movq	%rax, 64(%rsp)
	movl	8(%r15), %eax
	shrq	$8, %rcx
	cmpl	%ebp, %ecx
	movl	%eax, 72(%rsp)
	movzbl	12(%r15), %eax
	movb	%al, 76(%rsp)
	jg	.L319
	movq	48(%rsp), %rdx
	movq	32(%rsp), %rcx
	call	*%r12
	testb	%al, %al
	je	.L319
	movq	40(%rsp), %r11
	movslq	%r13d, %r13
	movq	64(%rsp), %rdx
	leaq	0(%r13,%r13,2), %rax
	leaq	0(%r13,%rax,4), %rax
	movl	$-1, %r13d
	addq	%r11, %rax
	cmpb	$0, 59(%rsp)
	movq	%rdx, (%rax)
	movl	72(%rsp), %edx
	movl	%edx, 8(%rax)
	movzbl	76(%rsp), %edx
	movb	%dl, 12(%rax)
	je	.L327
	movl	%r13d, %ecx
	xorl	%eax, %eax
	jmp	.L320
	.p2align 4,,10
.L351:
	movl	%ebp, %ecx
.L320:
	movl	1(%r11), %edx
	movl	%ecx, %ebp
	cmpl	%ecx, %edx
	cmovge	%edx, %ebp
	cmovg	%eax, %r13d
	addl	$1, %eax
	addq	$13, %r11
	cmpl	%eax, %r14d
	jg	.L351
	movl	%edi, %eax
	addq	$13, %r15
	addl	$1, %edi
	cmpl	%eax, %esi
	jg	.L322
	.p2align 4,,10
.L321:
	movl	60(%rsp), %edx
	movq	40(%rsp), %rcx
	call	_Z8ranksortP5Pointj
	jmp	.L348
.L327:
	movl	%r13d, %ebp
	jmp	.L319
	.p2align 4,,10
.L328:
	movl	$-1, %esi
	movl	$0, 60(%rsp)
	xorl	%ebx, %ebx
	movl	%esi, %ebp
	xorl	%r14d, %r14d
	jmp	.L308
	.seh_endproc
	.p2align 4,,15
	.globl	_Z9findHitsSPK4RectP5PointiS3_i
	.def	_Z9findHitsSPK4RectP5PointiS3_i;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9findHitsSPK4RectP5PointiS3_i
_Z9findHitsSPK4RectP5PointiS3_i:
.LFB71:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	.seh_endprologue
	testl	%r8d, %r8d
	jle	.L360
	subl	$1, %r8d
	leaq	(%r8,%r8,2), %rax
	leaq	(%r8,%rax,4), %rax
	leaq	13(%rdx,%rax), %r11
	xorl	%eax, %eax
	.p2align 4,,10
.L359:
	vmovss	5(%rdx), %xmm0
	movzbl	(%rdx), %r10d
	vcomiss	(%rcx), %xmm0
	movl	1(%rdx), %r8d
	vmovss	9(%rdx), %xmm1
	jb	.L354
	vcomiss	8(%rcx), %xmm0
	ja	.L354
	vcomiss	4(%rcx), %xmm1
	jb	.L354
	vcomiss	12(%rcx), %xmm1
	ja	.L354
	movslq	%eax, %rbx
	addl	$1, %eax
	leaq	(%rbx,%rbx,2), %rsi
	leaq	(%rbx,%rsi,4), %rbx
	addq	%r9, %rbx
	cmpl	56(%rsp), %eax
	movb	%r10b, (%rbx)
	movl	%r8d, 1(%rbx)
	vmovss	%xmm0, 5(%rbx)
	vmovss	%xmm1, 9(%rbx)
	je	.L365
	.p2align 4,,10
.L354:
	addq	$13, %rdx
	cmpq	%r11, %rdx
	jne	.L359
.L365:
	popq	%rbx
	popq	%rsi
	ret
.L360:
	xorl	%eax, %eax
	jmp	.L365
	.seh_endproc
	.p2align 4,,15
	.globl	_Z9findHitsVPK4RectPbPaPiPfS5_iP5Pointi
	.def	_Z9findHitsVPK4RectPbPaPiPfS5_iP5Pointi;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9findHitsVPK4RectPbPaPiPfS5_iP5Pointi
_Z9findHitsVPK4RectPbPaPiPfS5_iP5Pointi:
.LFB72:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	.seh_endprologue
	movl	88(%rsp), %r11d
	movq	72(%rsp), %rdi
	movq	80(%rsp), %rbp
	movq	96(%rsp), %rbx
	testl	%r11d, %r11d
	movl	104(%rsp), %esi
	jle	.L376
	vmovss	(%rcx), %xmm1
	xorl	%eax, %eax
	jmp	.L373
	.p2align 4,,10
.L388:
	vcomiss	8(%rcx), %xmm0
	ja	.L385
	vmovss	0(%rbp,%rax,4), %xmm0
	vcomiss	4(%rcx), %xmm0
	jb	.L385
	vcomiss	12(%rcx), %xmm0
	setbe	%r10b
	movb	%r10b, (%rdx,%rax)
	addq	$1, %rax
	cmpl	%eax, %r11d
	jle	.L387
	.p2align 4,,10
.L373:
	vmovss	(%rdi,%rax,4), %xmm0
	vcomiss	%xmm1, %xmm0
	jae	.L388
.L385:
	xorl	%r10d, %r10d
	movb	%r10b, (%rdx,%rax)
	addq	$1, %rax
	cmpl	%eax, %r11d
	jg	.L373
.L387:
	xorl	%ecx, %ecx
	xorl	%eax, %eax
	.p2align 4,,10
.L375:
	cmpb	$0, (%rdx,%rcx)
	je	.L374
	movslq	%eax, %r10
	addl	$1, %eax
	leaq	(%r10,%r10,2), %rdi
	leaq	(%r10,%rdi,4), %r10
	movzbl	(%r8,%rcx), %edi
	addq	%rbx, %r10
	cmpl	%esi, %eax
	movb	%dil, (%r10)
	movl	(%r9,%rcx,4), %edi
	movl	%edi, 1(%r10)
	je	.L386
.L374:
	addq	$1, %rcx
	cmpl	%ecx, %r11d
	jg	.L375
.L386:
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
.L376:
	xorl	%eax, %eax
	jmp	.L386
	.seh_endproc
	.p2align 4,,15
	.globl	_Z9findHitsBP17GumpSearchContextP4RectiPP5PointPiS6_S4_i
	.def	_Z9findHitsBP17GumpSearchContextP4RectiPP5PointPiS6_S4_i;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9findHitsBP17GumpSearchContextP4RectiPP5PointPiS6_S4_i
_Z9findHitsBP17GumpSearchContextP4RectiPP5PointPiS6_S4_i:
.LFB73:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$12, %rsp
	.seh_stackalloc	12
	.seh_endprologue
	movl	140(%rsp), %eax
	testl	%eax, %eax
	jle	.L403
	movl	$-1, %r13d
	movl	$0, (%rsp)
	movl	%r13d, %r14d
	.p2align 4,,10
.L391:
	testl	%r8d, %r8d
	jle	.L405
	movq	160(%rcx), %rbx
	xorl	%eax, %eax
	xorl	%esi, %esi
	movq	168(%rcx), %rbp
	movl	$100000000, %r12d
	jmp	.L402
	.p2align 4,,10
.L411:
	addl	$1, %esi
.L393:
	addq	$1, %rax
	cmpl	%eax, %r8d
	jle	.L401
.L402:
	movl	(%rbx,%rax,4), %r9d
	movl	%eax, %r11d
	cmpl	0(%rbp,%rax,4), %r9d
	jge	.L411
	movq	152(%rcx), %r10
	movq	(%r10,%rax,8), %rdi
	movslq	%r9d, %r10
	leaq	(%r10,%r10,2), %r15
	leaq	(%r10,%r15,4), %r15
	movl	1(%rdi,%r15), %r10d
	cmpl	%r10d, %r13d
	je	.L412
.L394:
	cmpl	%r12d, %r10d
	jge	.L393
	addq	$1, %rax
	movl	%r11d, %r14d
	movl	%r10d, %r12d
	cmpl	%eax, %r8d
	jg	.L402
.L401:
	cmpl	%r8d, %esi
	je	.L410
	movslq	%r14d, %r11
	movq	152(%rcx), %rsi
	leaq	0(,%r11,4), %rbx
	movq	%rbx, %r9
	addq	160(%rcx), %r9
	movl	(%r9), %r10d
	movslq	%r10d, %rax
	leaq	(%rax,%rax,2), %rdi
	leaq	(%rax,%rdi,4), %rax
	addq	(%rsi,%r11,8), %rax
	vmovss	5(%rax), %xmm0
	movzbl	(%rax), %esi
	vcomiss	(%rdx), %xmm0
	movl	1(%rax), %r11d
	vmovss	9(%rax), %xmm1
	jb	.L396
	vcomiss	8(%rdx), %xmm0
	ja	.L396
	vcomiss	4(%rdx), %xmm1
	jb	.L396
	vcomiss	12(%rdx), %xmm1
	ja	.L396
	movslq	(%rsp), %rax
	movl	%r11d, %r13d
	addl	$1, (%rsp)
	leaq	(%rax,%rax,2), %r9
	leaq	(%rax,%r9,4), %rax
	addq	132(%rsp), %rax
	movb	%sil, (%rax)
	movl	%r11d, 1(%rax)
	vmovss	%xmm0, 5(%rax)
	vmovss	%xmm1, 9(%rax)
	addq	160(%rcx), %rbx
	movl	(%rbx), %r10d
	movq	%rbx, %r9
	.p2align 4,,10
.L396:
	movl	(%rsp), %eax
	addl	$1, %r10d
	movl	%r10d, (%r9)
	cmpl	140(%rsp), %eax
	jl	.L391
.L410:
	movl	(%rsp), %eax
	addq	$12, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
.L412:
	addl	$1, %r9d
	movl	%r9d, (%rbx,%rax,4)
	movl	14(%rdi,%r15), %r10d
	jmp	.L394
.L405:
	xorl	%esi, %esi
	jmp	.L401
.L403:
	movl	$0, (%rsp)
	jmp	.L410
	.seh_endproc
	.p2align 4,,15
	.globl	_Z12searchBinaryP17GumpSearchContext4RectiP5Point
	.def	_Z12searchBinaryP17GumpSearchContext4RectiP5Point;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z12searchBinaryP17GumpSearchContext4RectiP5Point
_Z12searchBinaryP17GumpSearchContext4RectiP5Point:
.LFB74:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movl	(%rcx), %r12d
	movq	%rcx, %r13
	vmovss	(%rdx), %xmm2
	vmovss	4(%rdx), %xmm4
	vmovss	8(%rdx), %xmm3
	testl	%r12d, %r12d
	vmovss	12(%rdx), %xmm5
	movq	8(%rcx), %r10
	js	.L532
	movl	%r12d, %eax
	sarl	%eax
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %rcx
	leaq	(%rdx,%rcx,4), %rcx
	vmovss	5(%r10,%rcx), %xmm0
	vcomiss	%xmm0, %xmm2
	je	.L621
	vmovaps	%xmm0, %xmm1
	movl	%eax, %r15d
	movl	%r12d, %ebx
	xorl	%r11d, %r11d
	jmp	.L417
	.p2align 4,,10
.L623:
	leal	1(%r15), %r11d
	cmpl	%r11d, %ebx
	jl	.L622
.L425:
	leal	(%rbx,%r11), %ecx
	movl	%ecx, %r15d
	shrl	$31, %r15d
	addl	%ecx, %r15d
	sarl	%r15d
	movslq	%r15d, %rcx
	leaq	(%rcx,%rcx,2), %rsi
	leaq	(%rcx,%rsi,4), %rcx
	vmovss	5(%r10,%rcx), %xmm1
	vcomiss	%xmm2, %xmm1
	je	.L415
.L417:
	vcomiss	%xmm1, %xmm2
	ja	.L623
	leal	-1(%r15), %ebx
	cmpl	%r11d, %ebx
	jge	.L425
.L622:
	movl	%r11d, %r15d
.L530:
	xorl	%r11d, %r11d
	vcomiss	%xmm0, %xmm3
	movl	%r12d, %ecx
	jne	.L428
	jmp	.L636
	.p2align 4,,10
.L625:
	leal	1(%rax), %r11d
	cmpl	%ecx, %r11d
	jg	.L429
.L436:
	leal	(%r11,%rcx), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %rbx
	leaq	(%rdx,%rbx,4), %rbx
	vmovss	5(%r10,%rbx), %xmm0
	vcomiss	%xmm3, %xmm0
	je	.L426
.L428:
	vcomiss	%xmm0, %xmm3
	ja	.L625
	leal	-1(%rax), %ecx
	cmpl	%ecx, %r11d
	jle	.L436
.L429:
	subl	%r15d, %ecx
	xorl	%eax, %eax
	movl	%ecx, %r14d
	movl	%ecx, 44(%rsp)
	addl	$1, %r14d
	jne	.L626
.L620:
	addq	$56, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L621:
	movl	%eax, %r15d
	xorl	%r11d, %r11d
	.p2align 4,,10
.L415:
	cmpl	%r15d, %r11d
	jge	.L530
	vcomiss	-8(%r10,%rcx), %xmm2
	jne	.L530
	movslq	%r15d, %rcx
	leaq	(%rcx,%rcx,2), %rbx
	leaq	-26(%rcx,%rbx,4), %rcx
	leaq	5(%r10,%rcx), %rcx
	jmp	.L421
	.p2align 4,,10
.L627:
	subq	$13, %rcx
	vcomiss	13(%rcx), %xmm2
	jne	.L530
.L421:
	subl	$1, %r15d
	cmpl	%r11d, %r15d
	jne	.L627
	jmp	.L530
.L636:
	movl	%r12d, %ecx
	.p2align 4,,10
.L426:
	cmpl	%eax, %ecx
	jle	.L617
	addq	$1, %rdx
	leaq	(%rdx,%rdx,2), %r11
	leaq	(%rdx,%r11,4), %rdx
	vcomiss	5(%r10,%rdx), %xmm3
	jne	.L617
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r11
	leaq	26(%rdx,%r11,4), %rdx
	leaq	5(%r10,%rdx), %rdx
	jmp	.L432
	.p2align 4,,10
.L628:
	addq	$13, %rdx
	vcomiss	-13(%rdx), %xmm3
	jne	.L617
.L432:
	addl	$1, %eax
	cmpl	%ecx, %eax
	jne	.L628
.L617:
	movl	%eax, %ecx
	jmp	.L429
	.p2align 4,,10
.L626:
	testl	%r12d, %r12d
	movq	16(%r13), %rdi
	js	.L541
	movl	%r12d, %eax
	sarl	%eax
	movslq	%eax, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	leaq	(%rcx,%rdx,4), %r11
	vmovss	9(%rdi,%r11), %xmm0
	vcomiss	%xmm0, %xmm4
	je	.L629
	vmovaps	%xmm0, %xmm1
	movl	%eax, %edx
	movl	%r12d, %esi
	xorl	%ebx, %ebx
	jmp	.L441
	.p2align 4,,10
.L631:
	leal	1(%rdx), %ebx
	cmpl	%ebx, %esi
	jl	.L630
.L449:
	leal	(%rsi,%rbx), %edx
	movl	%edx, %r11d
	shrl	$31, %r11d
	addl	%r11d, %edx
	sarl	%edx
	movslq	%edx, %r11
	leaq	(%r11,%r11,2), %rbp
	leaq	(%r11,%rbp,4), %r11
	vmovss	9(%rdi,%r11), %xmm1
	vcomiss	%xmm4, %xmm1
	je	.L439
.L441:
	vcomiss	%xmm1, %xmm4
	ja	.L631
	leal	-1(%rdx), %esi
	cmpl	%ebx, %esi
	jge	.L449
.L630:
	movl	%ebx, %edx
.L531:
	xorl	%esi, %esi
	vcomiss	%xmm0, %xmm5
	movl	%r12d, %r11d
	jne	.L452
	jmp	.L637
	.p2align 4,,10
.L633:
	leal	1(%rax), %esi
	cmpl	%r11d, %esi
	jg	.L453
.L460:
	leal	(%rsi,%r11), %eax
	movl	%eax, %ecx
	shrl	$31, %ecx
	addl	%ecx, %eax
	sarl	%eax
	movslq	%eax, %rcx
	leaq	(%rcx,%rcx,2), %rbx
	leaq	(%rcx,%rbx,4), %rbx
	vmovss	9(%rdi,%rbx), %xmm0
	vcomiss	%xmm0, %xmm5
	je	.L450
.L452:
	vcomiss	%xmm0, %xmm5
	ja	.L633
	leal	-1(%rax), %r11d
	cmpl	%r11d, %esi
	jle	.L460
.L453:
	subl	%edx, %r11d
	xorl	%eax, %eax
	movl	%r11d, %ebx
	addl	$1, %ebx
	je	.L620
	cmpl	%ebx, %r14d
	jge	.L461
	cmpl	$15000, %r14d
	jg	.L462
	movslq	%r15d, %r15
	leaq	(%r15,%r15,2), %rax
	leaq	(%r15,%rax,4), %rax
	addq	%rax, %r10
	cmpl	%r8d, %r14d
	jle	.L472
	testl	%r8d, %r8d
	setg	%r12b
	testl	%r14d, %r14d
	jle	.L571
	testb	%r12b, %r12b
	je	.L571
	movl	$-1, %eax
	movq	%r10, %rdx
	xorl	%ebp, %ebp
	movl	%eax, %edi
	xorl	%r11d, %r11d
	jmp	.L482
	.p2align 4,,10
.L478:
	addl	$1, %r11d
	addq	$13, %rdx
	cmpl	%ebp, %r8d
	jle	.L481
	cmpl	%r11d, %r14d
	jle	.L481
.L482:
	vmovss	9(%rdx), %xmm0
	movzbl	(%rdx), %ebx
	vcomiss	%xmm4, %xmm0
	movl	1(%rdx), %ecx
	vmovss	5(%rdx), %xmm1
	jb	.L478
	vcomiss	%xmm0, %xmm5
	jb	.L478
	movslq	%ebp, %rsi
	leaq	(%rsi,%rsi,2), %r13
	leaq	(%rsi,%r13,4), %rsi
	addq	%r9, %rsi
	cmpl	%edi, %ecx
	movb	%bl, (%rsi)
	movl	%ecx, 1(%rsi)
	vmovss	%xmm1, 5(%rsi)
	vmovss	%xmm0, 9(%rsi)
	jle	.L524
	movl	%ebp, %eax
	movl	%ecx, %edi
.L524:
	addl	$1, %ebp
	jmp	.L478
.L629:
	movl	%eax, %edx
	xorl	%ebx, %ebx
	.p2align 4,,10
.L439:
	cmpl	%edx, %ebx
	jge	.L531
	vcomiss	-4(%rdi,%r11), %xmm4
	jne	.L531
	movslq	%edx, %r11
	leaq	(%r11,%r11,2), %rsi
	leaq	-26(%r11,%rsi,4), %r11
	leaq	9(%rdi,%r11), %r11
	jmp	.L445
	.p2align 4,,10
.L634:
	subq	$13, %r11
	vcomiss	13(%r11), %xmm4
	jne	.L531
.L445:
	subl	$1, %edx
	cmpl	%ebx, %edx
	jne	.L634
	jmp	.L531
.L637:
	movl	%r12d, %r11d
	.p2align 4,,10
.L450:
	cmpl	%eax, %r11d
	jle	.L619
	addq	$1, %rcx
	leaq	(%rcx,%rcx,2), %rbx
	leaq	(%rcx,%rbx,4), %rcx
	vcomiss	9(%rdi,%rcx), %xmm5
	jne	.L619
	movslq	%eax, %rcx
	leaq	(%rcx,%rcx,2), %rbx
	leaq	26(%rcx,%rbx,4), %rcx
	leaq	9(%rdi,%rcx), %rcx
	jmp	.L456
	.p2align 4,,10
.L635:
	addq	$13, %rcx
	vcomiss	-13(%rcx), %xmm5
	jne	.L619
.L456:
	addl	$1, %eax
	cmpl	%r11d, %eax
	jne	.L635
.L619:
	movl	%eax, %r11d
	jmp	.L453
	.p2align 4,,10
.L461:
	cmpl	$15000, %ebx
	jg	.L462
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx,2), %rax
	leaq	(%rdx,%rax,4), %rax
	addq	%rax, %rdi
	cmpl	%r8d, %ebx
	jle	.L498
	testl	%r8d, %r8d
	setg	%r14b
	testl	%ebx, %ebx
	jle	.L575
	testb	%r14b, %r14b
	je	.L575
	movl	$-1, %eax
	movq	%rdi, %rdx
	xorl	%r12d, %r12d
	movl	%eax, %ebp
	xorl	%r10d, %r10d
	jmp	.L508
	.p2align 4,,10
.L504:
	addl	$1, %r10d
	addq	$13, %rdx
	cmpl	%r12d, %r8d
	jle	.L507
	cmpl	%r10d, %ebx
	jle	.L507
.L508:
	vmovss	5(%rdx), %xmm0
	movzbl	(%rdx), %r11d
	vcomiss	%xmm2, %xmm0
	movl	1(%rdx), %ecx
	vmovss	9(%rdx), %xmm1
	jb	.L504
	vcomiss	%xmm0, %xmm3
	jb	.L504
	movslq	%r12d, %rsi
	leaq	(%rsi,%rsi,2), %r13
	leaq	(%rsi,%r13,4), %rsi
	addq	%r9, %rsi
	cmpl	%ebp, %ecx
	movb	%r11b, (%rsi)
	movl	%ecx, 1(%rsi)
	vmovss	%xmm0, 5(%rsi)
	vmovss	%xmm1, 9(%rsi)
	jle	.L527
	movl	%r12d, %eax
	movl	%ecx, %ebp
.L527:
	addl	$1, %r12d
	jmp	.L504
.L498:
	xorl	%edx, %edx
	xorl	%r12d, %r12d
	testl	%ebx, %ebx
	jle	.L503
	leaq	(%r11,%r11,2), %rax
	xorl	%r12d, %r12d
	leaq	(%r11,%rax,4), %rax
	leaq	13(%rdi,%rax), %rcx
	.p2align 4,,10
.L523:
	vmovss	5(%rdi), %xmm0
	movzbl	(%rdi), %edx
	vcomiss	%xmm2, %xmm0
	movl	1(%rdi), %eax
	vmovss	9(%rdi), %xmm1
	jb	.L519
	vcomiss	%xmm0, %xmm3
	jb	.L519
	movslq	%r12d, %r8
	addl	$1, %r12d
	leaq	(%r8,%r8,2), %r10
	leaq	(%r8,%r10,4), %r8
	addq	%r9, %r8
	movb	%dl, (%r8)
	movl	%eax, 1(%r8)
	vmovss	%xmm0, 5(%r8)
	vmovss	%xmm1, 9(%r8)
	.p2align 4,,10
.L519:
	addq	$13, %rdi
	cmpq	%rcx, %rdi
	jne	.L523
	movl	%r12d, %edx
.L503:
	movq	%r9, %rcx
	call	_Z8ranksortP5Pointj
	movl	%r12d, %eax
	jmp	.L620
.L507:
	movl	%r12d, %edx
.L501:
	cmpl	%ebx, %r10d
	jge	.L503
	leal	1(%r10), %r13d
	movslq	%r10d, %rcx
	leaq	(%rcx,%rcx,2), %r11
	leaq	(%rcx,%r11,4), %rcx
	addq	%rdi, %rcx
	jmp	.L518
	.p2align 4,,10
.L513:
	movl	%r13d, %r10d
	addq	$13, %rcx
	addl	$1, %r13d
	cmpl	%r10d, %ebx
	jle	.L503
.L518:
	movl	1(%rcx), %r10d
	movzbl	(%rcx), %r11d
	vmovss	5(%rcx), %xmm0
	vmovss	9(%rcx), %xmm1
	cmpl	%ebp, %r10d
	jg	.L513
	vcomiss	%xmm2, %xmm0
	jb	.L513
	vcomiss	%xmm0, %xmm3
	jb	.L513
	cltq
	leaq	(%rax,%rax,2), %rsi
	leaq	(%rax,%rsi,4), %rax
	addq	%r9, %rax
	testb	%r14b, %r14b
	movb	%r11b, (%rax)
	movl	%r10d, 1(%rax)
	vmovss	%xmm0, 5(%rax)
	vmovss	%xmm1, 9(%rax)
	je	.L554
	movl	$-1, %eax
	movq	%r9, %rdi
	xorl	%r10d, %r10d
	movl	%eax, %esi
	jmp	.L529
	.p2align 4,,10
.L516:
	movl	%ebp, %esi
.L529:
	movl	1(%rdi), %r11d
	movl	%esi, %ebp
	cmpl	%esi, %r11d
	cmovge	%r11d, %ebp
	cmovg	%r10d, %eax
	addl	$1, %r10d
	addq	$13, %rdi
	cmpl	%r10d, %r8d
	jg	.L516
	jmp	.L513
.L472:
	xorl	%edx, %edx
	xorl	%ebp, %ebp
	testl	%r14d, %r14d
	jle	.L477
	movl	44(%rsp), %eax
	xorl	%ebp, %ebp
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %rax
	leaq	13(%r10,%rax), %rcx
	.p2align 4,,10
.L497:
	vmovss	9(%r10), %xmm0
	movzbl	(%r10), %edx
	vcomiss	%xmm4, %xmm0
	movl	1(%r10), %eax
	vmovss	5(%r10), %xmm1
	jb	.L493
	vcomiss	%xmm0, %xmm5
	jb	.L493
	movslq	%ebp, %r8
	addl	$1, %ebp
	leaq	(%r8,%r8,2), %r11
	leaq	(%r8,%r11,4), %r8
	addq	%r9, %r8
	movb	%dl, (%r8)
	movl	%eax, 1(%r8)
	vmovss	%xmm1, 5(%r8)
	vmovss	%xmm0, 9(%r8)
	.p2align 4,,10
.L493:
	addq	$13, %r10
	cmpq	%rcx, %r10
	jne	.L497
	movl	%ebp, %edx
.L477:
	movq	%r9, %rcx
	call	_Z8ranksortP5Pointj
	movl	%ebp, %eax
	jmp	.L620
.L575:
	movl	$-1, %eax
	xorl	%edx, %edx
	xorl	%r12d, %r12d
	movl	%eax, %ebp
	xorl	%r10d, %r10d
	jmp	.L501
.L462:
	testl	%r12d, %r12d
	movq	40(%r13), %rdx
	jle	.L550
	subl	$1, %r12d
	leaq	(%r12,%r12,2), %rax
	leaq	(%r12,%rax,4), %rax
	leaq	13(%rdx,%rax), %r11
	xorl	%eax, %eax
	.p2align 4,,10
.L471:
	vmovss	5(%rdx), %xmm0
	movzbl	(%rdx), %r10d
	vcomiss	%xmm2, %xmm0
	movl	1(%rdx), %ecx
	vmovss	9(%rdx), %xmm1
	jb	.L466
	vcomiss	%xmm0, %xmm3
	jb	.L466
	vcomiss	%xmm4, %xmm1
	jb	.L466
	vcomiss	%xmm1, %xmm5
	jb	.L466
	movslq	%eax, %rbx
	addl	$1, %eax
	leaq	(%rbx,%rbx,2), %rsi
	leaq	(%rbx,%rsi,4), %rbx
	addq	%r9, %rbx
	cmpl	%eax, %r8d
	movb	%r10b, (%rbx)
	movl	%ecx, 1(%rbx)
	vmovss	%xmm0, 5(%rbx)
	vmovss	%xmm1, 9(%rbx)
	je	.L620
	.p2align 4,,10
.L466:
	addq	$13, %rdx
	cmpq	%r11, %rdx
	jne	.L471
	jmp	.L620
.L532:
	movl	%r12d, %ecx
	xorl	%r15d, %r15d
	jmp	.L429
.L481:
	movl	%ebp, %edx
.L475:
	cmpl	%r11d, %r14d
	jle	.L477
	leal	1(%r11), %r13d
	movslq	%r11d, %rcx
	leaq	(%rcx,%rcx,2), %rbx
	leaq	(%rcx,%rbx,4), %rcx
	addq	%r10, %rcx
	jmp	.L492
	.p2align 4,,10
.L487:
	movl	%r13d, %r10d
	addq	$13, %rcx
	addl	$1, %r13d
	cmpl	%r10d, %r14d
	jle	.L477
.L492:
	movl	1(%rcx), %r10d
	movzbl	(%rcx), %r11d
	vmovss	5(%rcx), %xmm1
	vmovss	9(%rcx), %xmm0
	cmpl	%edi, %r10d
	jg	.L487
	vcomiss	%xmm4, %xmm0
	jb	.L487
	vcomiss	%xmm0, %xmm5
	jb	.L487
	cltq
	leaq	(%rax,%rax,2), %rbx
	leaq	(%rax,%rbx,4), %rax
	addq	%r9, %rax
	testb	%r12b, %r12b
	movb	%r11b, (%rax)
	movl	%r10d, 1(%rax)
	vmovss	%xmm1, 5(%rax)
	vmovss	%xmm0, 9(%rax)
	je	.L552
	movl	$-1, %eax
	movq	%r9, %rsi
	xorl	%r10d, %r10d
	movl	%eax, %ebx
	jmp	.L526
	.p2align 4,,10
.L490:
	movl	%edi, %ebx
.L526:
	movl	1(%rsi), %r11d
	movl	%ebx, %edi
	cmpl	%ebx, %r11d
	cmovge	%r11d, %edi
	cmovg	%r10d, %eax
	addl	$1, %r10d
	addq	$13, %rsi
	cmpl	%r10d, %r8d
	jg	.L490
	jmp	.L487
.L541:
	movl	%r12d, %r11d
	xorl	%edx, %edx
	jmp	.L453
.L571:
	movl	$-1, %eax
	xorl	%edx, %edx
	xorl	%ebp, %ebp
	movl	%eax, %edi
	xorl	%r11d, %r11d
	jmp	.L475
.L554:
	movl	$-1, %eax
	movl	%eax, %ebp
	jmp	.L513
.L552:
	movl	$-1, %eax
	movl	%eax, %edi
	jmp	.L487
.L550:
	xorl	%eax, %eax
	jmp	.L620
	.seh_endproc
	.p2align 4,,15
	.globl	_Z10regionHitsP17GumpSearchContext4RectP6RegioniP5Pointi
	.def	_Z10regionHitsP17GumpSearchContext4RectP6RegioniP5Pointi;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10regionHitsP17GumpSearchContext4RectP6RegioniP5Pointi
_Z10regionHitsP17GumpSearchContext4RectP6RegioniP5Pointi:
.LFB75:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	.seh_endprologue
	movl	80(%rsp), %esi
	vmovss	(%rdx), %xmm0
	vmovss	4(%rdx), %xmm1
	vmovss	8(%rdx), %xmm3
	vmovss	12(%rdx), %xmm4
	leal	1(%rsi), %edx
	movq	72(%rsp), %rax
	jmp	.L639
	.p2align 4,,10
.L733:
	vcomiss	4(%r11), %xmm1
	jb	.L651
	vcomiss	8(%r11), %xmm3
	ja	.L651
	vcomiss	12(%r11), %xmm4
	ja	.L651
	movq	%r10, %r8
.L655:
	addl	$1, %edx
.L639:
	movl	(%r8), %r10d
	leal	-1(%rdx), %ebx
	testl	%r10d, %r10d
	je	.L685
	movq	40(%r8), %r10
	testq	%r10, %r10
	je	.L732
	movq	24(%r10), %r11
	vcomiss	(%r11), %xmm0
	jae	.L733
.L651:
	movq	48(%r8), %r11
	movq	24(%r11), %r10
	vcomiss	(%r10), %xmm0
	jb	.L656
	vcomiss	4(%r10), %xmm1
	jb	.L656
	vcomiss	8(%r10), %xmm3
	ja	.L656
	vcomiss	12(%r10), %xmm4
	jbe	.L697
	.p2align 4,,10
.L656:
	movq	64(%r8), %r11
	movq	24(%r11), %r10
	vcomiss	(%r10), %xmm0
	jb	.L659
	vcomiss	4(%r10), %xmm1
	jb	.L659
	vcomiss	8(%r10), %xmm3
	jbe	.L734
	.p2align 4,,10
.L659:
	movq	72(%r8), %r11
	movq	24(%r11), %r10
	vcomiss	(%r10), %xmm0
	jb	.L662
	vcomiss	4(%r10), %xmm1
	jb	.L662
	vcomiss	8(%r10), %xmm3
	ja	.L662
	vcomiss	12(%r10), %xmm4
	jbe	.L697
	.p2align 4,,10
.L662:
	movq	56(%r8), %r11
	movq	24(%r11), %r10
	vcomiss	(%r10), %xmm0
	jb	.L665
	vcomiss	4(%r10), %xmm1
	jae	.L735
	.p2align 4,,10
.L665:
	movq	80(%r8), %r11
	movq	24(%r11), %r10
	vcomiss	(%r10), %xmm0
	jb	.L668
	vcomiss	4(%r10), %xmm1
	jb	.L668
	vcomiss	8(%r10), %xmm3
	ja	.L668
	vcomiss	12(%r10), %xmm4
	jbe	.L697
.L668:
	movq	16(%r8), %rdx
	movq	64(%rcx), %rcx
	movl	(%rdx), %r8d
	movq	32(%rdx), %rdi
	movq	24(%rdx), %r10
	movq	16(%rdx), %r11
	testl	%r8d, %r8d
	movq	8(%rdx), %rsi
	jle	.L703
	xorl	%edx, %edx
.L684:
	vmovss	(%r10,%rdx,4), %xmm2
	vcomiss	%xmm0, %xmm2
	jae	.L736
.L729:
	xorl	%ebp, %ebp
.L671:
	movb	%bpl, (%rcx,%rdx)
	addq	$1, %rdx
	cmpl	%edx, %r8d
	jg	.L684
	xorl	%edx, %edx
	xorl	%r10d, %r10d
	.p2align 4,,10
.L678:
	cmpb	$0, (%rcx,%rdx)
	je	.L676
	movslq	%r10d, %rdi
	addl	$1, %r10d
	leaq	(%rdi,%rdi,2), %rbp
	leaq	(%rdi,%rbp,4), %rdi
	movzbl	(%rsi,%rdx), %ebp
	addq	%rax, %rdi
	cmpl	%r10d, %r9d
	movb	%bpl, (%rdi)
	movl	(%r11,%rdx,4), %ebp
	movl	%ebp, 1(%rdi)
	je	.L701
.L676:
	addq	$1, %rdx
	cmpl	%edx, %r8d
	jg	.L678
.L677:
	movl	%ebx, %eax
	negl	%eax
	cmpl	%r10d, %r9d
	cmovle	%r10d, %eax
	jmp	.L730
	.p2align 4,,10
.L735:
	vcomiss	8(%r10), %xmm3
	ja	.L665
	vcomiss	12(%r10), %xmm4
	ja	.L665
	.p2align 4,,10
.L697:
	movq	%r11, %r8
	jmp	.L655
	.p2align 4,,10
.L685:
	xorl	%eax, %eax
.L730:
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
	.p2align 4,,10
.L734:
	vcomiss	12(%r10), %xmm4
	ja	.L659
	movq	%r11, %r8
	jmp	.L655
	.p2align 4,,10
.L732:
	movq	16(%r8), %rdx
	movq	64(%rcx), %r11
	movl	(%rdx), %r10d
	movq	32(%rdx), %rbp
	movq	24(%rdx), %r8
	movq	16(%rdx), %rsi
	testl	%r10d, %r10d
	movq	8(%rdx), %rdi
	jle	.L686
	xorl	%edx, %edx
	jmp	.L648
	.p2align 4,,10
.L738:
	vcomiss	%xmm2, %xmm3
	jb	.L725
	vmovss	0(%rbp,%rdx,4), %xmm2
	vcomiss	%xmm1, %xmm2
	jb	.L725
	vcomiss	%xmm2, %xmm4
	setae	%cl
	movb	%cl, (%r11,%rdx)
	addq	$1, %rdx
	cmpl	%edx, %r10d
	jle	.L737
	.p2align 4,,10
.L648:
	vmovss	(%r8,%rdx,4), %xmm2
	vcomiss	%xmm0, %xmm2
	jae	.L738
.L725:
	xorl	%ecx, %ecx
	movb	%cl, (%r11,%rdx)
	addq	$1, %rdx
	cmpl	%edx, %r10d
	jg	.L648
.L737:
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	.p2align 4,,10
.L650:
	cmpb	$0, (%r11,%rdx)
	je	.L649
	movslq	%ecx, %r8
	addl	$1, %ecx
	leaq	(%r8,%r8,2), %rbp
	leaq	(%r8,%rbp,4), %r8
	movzbl	(%rdi,%rdx), %ebp
	addq	%rax, %r8
	cmpl	%ecx, %r9d
	movb	%bpl, (%r8)
	movl	(%rsi,%rdx,4), %ebp
	movl	%ebp, 1(%r8)
	je	.L701
.L649:
	addq	$1, %rdx
	cmpl	%edx, %r10d
	jg	.L650
.L642:
	negl	%ebx
	movl	%ecx, %eax
	cmpl	%ecx, %r9d
	cmovg	%ebx, %eax
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
.L736:
	vcomiss	%xmm2, %xmm3
	jb	.L729
	vmovss	(%rdi,%rdx,4), %xmm2
	vcomiss	%xmm1, %xmm2
	jb	.L729
	vcomiss	%xmm2, %xmm4
	setae	%bpl
	jmp	.L671
.L701:
	movl	%r9d, %eax
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	ret
.L686:
	xorl	%ecx, %ecx
	jmp	.L642
.L703:
	xorl	%r10d, %r10d
	jmp	.L677
	.seh_endproc
	.p2align 4,,15
	.globl	_Z14searchGumptionP17GumpSearchContext4RectiP5Point
	.def	_Z14searchGumptionP17GumpSearchContext4RectiP5Point;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z14searchGumptionP17GumpSearchContext4RectiP5Point
_Z14searchGumptionP17GumpSearchContext4RectiP5Point:
.LFB76:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$232, %rsp
	.seh_stackalloc	232
	vmovaps	%xmm6, 144(%rsp)
	.seh_savexmm	%xmm6, 144
	vmovaps	%xmm7, 160(%rsp)
	.seh_savexmm	%xmm7, 160
	vmovaps	%xmm8, 176(%rsp)
	.seh_savexmm	%xmm8, 176
	vmovaps	%xmm9, 192(%rsp)
	.seh_savexmm	%xmm9, 192
	vmovaps	%xmm10, 208(%rsp)
	.seh_savexmm	%xmm10, 208
	.seh_endprologue
	movq	56(%rcx), %rax
	movq	%rdx, %rbp
	movq	%rcx, %rbx
	vmovss	(%rdx), %xmm1
	movl	%r8d, %r12d
	movq	%r9, %r13
	vmovss	8(%rdx), %xmm3
	vmovss	4(%rdx), %xmm0
	vmovss	12(%rdx), %xmm2
	vmovss	%xmm1, (%rax)
	movq	120(%rcx), %rdx
	vmovss	%xmm3, 8(%rax)
	vmovss	%xmm0, 4(%rax)
	vmovss	%xmm2, 12(%rax)
	vmovss	(%rdx), %xmm4
	vcomiss	%xmm1, %xmm4
	jbe	.L740
	vmovss	%xmm4, (%rax)
.L740:
	vmovss	8(%rdx), %xmm1
	vcomiss	%xmm1, %xmm3
	jbe	.L742
	vmovss	%xmm1, 8(%rax)
.L742:
	vmovss	4(%rdx), %xmm1
	vcomiss	%xmm0, %xmm1
	jbe	.L744
	vmovss	%xmm1, 4(%rax)
.L744:
	vmovss	12(%rdx), %xmm0
	vcomiss	%xmm0, %xmm2
	jbe	.L746
	vmovss	%xmm0, 12(%rax)
.L746:
	movq	8(%rax), %rdx
	movl	%r12d, %r9d
	movq	%rbx, %rcx
	movq	(%rax), %rax
	movl	$1, 40(%rsp)
	movq	%r13, 32(%rsp)
	movq	48(%rbx), %r8
	movq	%rdx, 136(%rsp)
	leaq	128(%rsp), %rdx
	movq	%rax, 128(%rsp)
	call	_Z10regionHitsP17GumpSearchContext4RectP6RegioniP5Pointi
	testl	%eax, %eax
	jle	.L992
.L988:
	vmovaps	144(%rsp), %xmm6
	vmovaps	160(%rsp), %xmm7
	vmovaps	176(%rsp), %xmm8
	vmovaps	192(%rsp), %xmm9
	vmovaps	208(%rsp), %xmm10
	addq	$232, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
.L992:
	movl	(%rbx), %ecx
	vmovss	0(%rbp), %xmm0
	movq	8(%rbx), %r10
	testl	%ecx, %ecx
	js	.L749
	movl	%ecx, %eax
	sarl	%eax
	movslq	%eax, %rsi
	leaq	(%rsi,%rsi,2), %rdx
	leaq	(%rsi,%rdx,4), %r8
	vmovss	5(%r10,%r8), %xmm2
	vcomiss	%xmm2, %xmm0
	je	.L993
	vmovaps	%xmm2, %xmm1
	movl	%eax, %edx
	movl	%ecx, %r11d
	xorl	%r9d, %r9d
	jmp	.L752
	.p2align 4,,10
.L995:
	leal	1(%rdx), %r9d
.L759:
	cmpl	%r9d, %r11d
	jl	.L994
	leal	(%r11,%r9), %edx
	movl	%edx, %r8d
	shrl	$31, %r8d
	addl	%r8d, %edx
	sarl	%edx
	movslq	%edx, %r8
	leaq	(%r8,%r8,2), %rdi
	leaq	(%r8,%rdi,4), %r8
	vmovss	5(%r10,%r8), %xmm1
	vcomiss	%xmm1, %xmm0
	je	.L750
.L752:
	vcomiss	%xmm1, %xmm0
	ja	.L995
	leal	-1(%rdx), %r11d
	jmp	.L759
.L993:
	movl	%eax, %edx
	xorl	%r9d, %r9d
	.p2align 4,,10
.L750:
	cmpl	%edx, %r9d
	jge	.L753
	vcomiss	-8(%r10,%r8), %xmm0
	jne	.L753
	movslq	%edx, %r8
	leaq	(%r8,%r8,2), %r11
	leaq	-26(%r8,%r11,4), %r8
	leaq	5(%r10,%r8), %r8
	jmp	.L756
	.p2align 4,,10
.L996:
	subq	$13, %r8
	vcomiss	13(%r8), %xmm0
	jne	.L753
.L756:
	subl	$1, %edx
	cmpl	%r9d, %edx
	jne	.L996
.L753:
	vmovss	8(%rbp), %xmm1
	movl	%edx, 80(%rsp)
.L882:
	xorl	%r9d, %r9d
	vcomiss	%xmm2, %xmm1
	movl	%ecx, %r8d
	jne	.L763
	jmp	.L1007
	.p2align 4,,10
.L998:
	leal	1(%rax), %r9d
.L770:
	cmpl	%r8d, %r9d
	jg	.L884
	leal	(%r9,%r8), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r11
	leaq	(%rdx,%r11,4), %r11
	vmovss	5(%r10,%r11), %xmm2
	vcomiss	%xmm2, %xmm1
	je	.L761
.L763:
	vcomiss	%xmm2, %xmm1
	ja	.L998
	leal	-1(%rax), %r8d
	jmp	.L770
.L749:
	vmovss	8(%rbp), %xmm1
	movl	%ecx, %r8d
	movl	$0, 80(%rsp)
	.p2align 4,,10
.L884:
	movl	%r8d, %eax
.L764:
	subl	80(%rsp), %eax
	movl	%eax, 92(%rsp)
	addl	$1, %eax
	movl	%eax, 84(%rsp)
	jne	.L772
.L901:
	xorl	%eax, %eax
	jmp	.L988
	.p2align 4,,10
.L772:
	testl	%ecx, %ecx
	vmovss	4(%rbp), %xmm2
	movq	16(%rbx), %r11
	js	.L773
	movl	%ecx, %eax
	sarl	%eax
	movslq	%eax, %rdi
	leaq	(%rdi,%rdi,2), %rdx
	leaq	(%rdi,%rdx,4), %r8
	vmovss	9(%r11,%r8), %xmm3
	vcomiss	%xmm3, %xmm2
	je	.L999
	vmovaps	%xmm3, %xmm4
	movl	%eax, %edx
	movl	%ecx, %r10d
	xorl	%r9d, %r9d
	jmp	.L776
	.p2align 4,,10
.L1001:
	leal	1(%rdx), %r9d
.L783:
	cmpl	%r9d, %r10d
	jl	.L1000
	leal	(%r10,%r9), %edx
	movl	%edx, %r8d
	shrl	$31, %r8d
	addl	%r8d, %edx
	sarl	%edx
	movslq	%edx, %r8
	leaq	(%r8,%r8,2), %rsi
	leaq	(%r8,%rsi,4), %r8
	vmovss	9(%r11,%r8), %xmm4
	vcomiss	%xmm4, %xmm2
	je	.L774
.L776:
	vcomiss	%xmm4, %xmm2
	ja	.L1001
	leal	-1(%rdx), %r10d
	jmp	.L783
.L1007:
	movq	%rsi, %rdx
	movl	%ecx, %r8d
	.p2align 4,,10
.L761:
	cmpl	%eax, %r8d
	jle	.L764
	addq	$1, %rdx
	leaq	(%rdx,%rdx,2), %r9
	leaq	(%rdx,%r9,4), %rdx
	vcomiss	5(%r10,%rdx), %xmm1
	jne	.L764
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r9
	leaq	26(%rdx,%r9,4), %rdx
	leaq	5(%r10,%rdx), %rdx
	jmp	.L767
	.p2align 4,,10
.L1002:
	addq	$13, %rdx
	vcomiss	-13(%rdx), %xmm1
	jne	.L764
.L767:
	addl	$1, %eax
	cmpl	%r8d, %eax
	jne	.L1002
	jmp	.L764
	.p2align 4,,10
.L994:
	vmovss	8(%rbp), %xmm1
	movl	%r9d, 80(%rsp)
	jmp	.L882
.L999:
	movl	%eax, %edx
	xorl	%r9d, %r9d
.L774:
	cmpl	%edx, %r9d
	jge	.L777
	vcomiss	-4(%r11,%r8), %xmm2
	jne	.L777
	movslq	%edx, %r8
	leaq	(%r8,%r8,2), %r10
	leaq	-26(%r8,%r10,4), %r8
	leaq	9(%r11,%r8), %r8
	jmp	.L780
	.p2align 4,,10
.L1003:
	subq	$13, %r8
	vcomiss	13(%r8), %xmm2
	jne	.L777
.L780:
	subl	$1, %edx
	cmpl	%r9d, %edx
	jne	.L1003
.L777:
	vmovss	12(%rbp), %xmm4
	movl	%edx, 96(%rsp)
.L883:
	xorl	%edx, %edx
	vcomiss	%xmm3, %xmm4
	jne	.L787
	jmp	.L785
	.p2align 4,,10
.L1004:
	leal	1(%rax), %edx
.L794:
	cmpl	%ecx, %edx
	jg	.L885
	leal	(%rdx,%rcx), %eax
	movl	%eax, %r8d
	shrl	$31, %r8d
	addl	%r8d, %eax
	sarl	%eax
	movslq	%eax, %rdi
	leaq	(%rdi,%rdi,2), %r8
	leaq	(%rdi,%r8,4), %r8
	vmovss	9(%r11,%r8), %xmm3
	vcomiss	%xmm3, %xmm4
	je	.L785
.L787:
	vcomiss	%xmm3, %xmm4
	ja	.L1004
	leal	-1(%rax), %ecx
	jmp	.L794
.L773:
	vmovss	12(%rbp), %xmm4
	movl	$0, 96(%rsp)
.L885:
	movl	%ecx, %eax
.L788:
	subl	96(%rsp), %eax
	movl	%eax, 124(%rsp)
	addl	$1, %eax
	movl	%eax, 100(%rsp)
	je	.L901
	movq	56(%rbx), %rcx
	xorl	%edx, %edx
	movq	120(%rbx), %rax
	vmovsd	136(%rbx), %xmm6
	vmovsd	144(%rbx), %xmm3
	vmovss	(%rcx), %xmm9
	vmovss	(%rax), %xmm7
	vmovss	4(%rax), %xmm5
	vsubss	%xmm7, %xmm9, %xmm10
	vmovss	4(%rcx), %xmm8
	movq	96(%rbx), %r11
	vunpcklps	%xmm10, %xmm10, %xmm10
	vcvtps2pd	%xmm10, %xmm10
	vdivsd	%xmm6, %xmm10, %xmm10
	vroundsd	$1, %xmm10, %xmm10, %xmm10
	vcvttsd2si	%xmm10, %r8d
	vsubss	%xmm5, %xmm8, %xmm10
	vunpcklps	%xmm10, %xmm10, %xmm10
	vcvtps2pd	%xmm10, %xmm10
	vdivsd	%xmm3, %xmm10, %xmm10
	testl	%r8d, %r8d
	cmovs	%edx, %r8d
	movslq	%r8d, %r10
	leaq	0(,%r10,8), %rsi
	vroundsd	$1, %xmm10, %xmm10, %xmm10
	vcvttsd2si	%xmm10, %eax
	vmovss	8(%rcx), %xmm10
	vsubss	%xmm7, %xmm10, %xmm7
	testl	%eax, %eax
	vunpcklps	%xmm7, %xmm7, %xmm7
	vcvtps2pd	%xmm7, %xmm7
	vdivsd	%xmm6, %xmm7, %xmm6
	cmovs	%edx, %eax
	vroundsd	$2, %xmm6, %xmm6, %xmm6
	vcvttsd2si	%xmm6, %edx
	vmovss	12(%rcx), %xmm6
	movl	$150, %ecx
	vsubss	%xmm5, %xmm6, %xmm5
	cmpl	$150, %edx
	vunpcklps	%xmm5, %xmm5, %xmm5
	vcvtps2pd	%xmm5, %xmm5
	vdivsd	%xmm3, %xmm5, %xmm3
	cmovg	%ecx, %edx
	subl	%r8d, %edx
	vroundsd	$2, %xmm3, %xmm3, %xmm3
	vcvttsd2si	%xmm3, %r9d
	cmpl	$150, %r9d
	cmovle	%r9d, %ecx
	movslq	%eax, %r9
	salq	$4, %r9
	movq	%r9, %rdi
	subl	%eax, %ecx
	addq	(%r11,%r10,8), %rdi
	vcomiss	(%rdi), %xmm9
	movq	%rdi, %r10
	jae	.L797
	movq	%r9, %r10
	subl	$1, %r8d
	addq	-8(%r11,%rsi), %r10
.L797:
	xorl	%r9d, %r9d
	vcomiss	4(%r10), %xmm8
	setb	%r9b
	subl	%r9d, %eax
	testl	%edx, %edx
	jle	.L901
	cltq
	movslq	%r8d, %r8
	subl	$1, %edx
	leaq	1(%r8,%rdx), %r15
	movq	%rbp, 104(%rsp)
	leaq	0(,%rax,4), %rsi
	movl	%r12d, 120(%rsp)
	salq	$3, %r15
	leaq	0(,%rax,8), %rdx
	movq	%rsi, 72(%rsp)
	movq	%rax, %rsi
	movq	%rdx, %r14
	salq	$4, %rsi
	movl	$0, 88(%rsp)
	leal	-1(%rcx), %edx
	movq	%r14, %rbp
	movq	%rsi, %r12
	leaq	1(%rax,%rdx), %rdx
	movq	%r13, 112(%rsp)
	leaq	0(,%r8,8), %rdi
	salq	$2, %rdx
	xorl	%r8d, %r8d
	.p2align 4,,10
.L801:
	testl	%ecx, %ecx
	jle	.L809
	movq	72(%rsp), %rax
	movq	%rbp, %r10
	movq	%r12, %r9
	.p2align 4,,10
.L810:
	movq	112(%rbx), %r11
	movq	(%r11,%rdi), %r11
	movl	(%r11,%rax), %r11d
	testl	%r11d, %r11d
	je	.L802
	movq	104(%rbx), %rsi
	movq	%r9, %r14
	addq	(%rsi,%rdi), %r14
	vcomiss	8(%r14), %xmm0
	ja	.L802
	vcomiss	(%r14), %xmm1
	jb	.L802
	vcomiss	12(%r14), %xmm2
	ja	.L802
	vcomiss	4(%r14), %xmm4
	jb	.L802
	movq	80(%rbx), %r13
	movslq	%r8d, %rsi
	addl	$1, %r8d
	addl	%r11d, 88(%rsp)
	movq	0(%r13,%rdi), %r13
	movq	0(%r13,%r10), %r14
	movq	152(%rbx), %r13
	movq	%r14, 0(%r13,%rsi,8)
	movq	160(%rbx), %r13
	movl	$0, 0(%r13,%rsi,4)
	movq	168(%rbx), %r13
	movl	%r11d, 0(%r13,%rsi,4)
	.p2align 4,,10
.L802:
	addq	$4, %rax
	addq	$16, %r9
	addq	$8, %r10
	cmpq	%rdx, %rax
	jne	.L810
.L809:
	addq	$8, %rdi
	cmpq	%r15, %rdi
	jne	.L801
	testl	%r8d, %r8d
	movq	104(%rsp), %rbp
	movl	120(%rsp), %r12d
	movq	112(%rsp), %r13
	je	.L901
	movl	100(%rsp), %eax
	vcvtsi2ss	88(%rsp), %xmm3, %xmm3
	cmpl	%eax, 84(%rsp)
	vmulss	.LC0(%rip), %xmm3, %xmm3
	jge	.L811
	vcvtsi2ss	84(%rsp), %xmm5, %xmm5
	vcomiss	%xmm3, %xmm5
	ja	.L812
	movslq	80(%rsp), %rax
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %r10
	addq	8(%rbx), %r10
	cmpl	84(%rsp), %r12d
	jge	.L824
	movl	84(%rsp), %r8d
	testl	%r12d, %r12d
	setg	%dil
	testl	%r8d, %r8d
	jle	.L931
	testb	%dil, %dil
	je	.L931
	movl	$-1, %eax
	movq	%r10, %rcx
	xorl	%esi, %esi
	movl	%eax, %ebx
	xorl	%r8d, %r8d
	movl	84(%rsp), %r11d
	jmp	.L834
	.p2align 4,,10
.L830:
	addl	$1, %r8d
	addq	$13, %rcx
	cmpl	%esi, %r12d
	jle	.L833
	cmpl	%r8d, %r11d
	jle	.L833
.L834:
	vmovss	9(%rcx), %xmm0
	movzbl	(%rcx), %r9d
	vcomiss	%xmm2, %xmm0
	movl	1(%rcx), %edx
	vmovss	5(%rcx), %xmm1
	jb	.L830
	vcomiss	%xmm0, %xmm4
	jb	.L830
	movslq	%esi, %rbp
	leaq	0(%rbp,%rbp,2), %r14
	leaq	0(%rbp,%r14,4), %rbp
	addq	%r13, %rbp
	cmpl	%ebx, %edx
	movb	%r9b, 0(%rbp)
	movl	%edx, 1(%rbp)
	vmovss	%xmm1, 5(%rbp)
	vmovss	%xmm0, 9(%rbp)
	jle	.L876
	movl	%esi, %eax
	movl	%edx, %ebx
.L876:
	addl	$1, %esi
	jmp	.L830
.L785:
	cmpl	%ecx, %eax
	jge	.L788
	leaq	1(%rdi), %rdx
	leaq	(%rdx,%rdx,2), %r8
	leaq	(%rdx,%r8,4), %rdx
	vcomiss	9(%r11,%rdx), %xmm4
	jne	.L788
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r8
	leaq	26(%rdx,%r8,4), %rdx
	leaq	9(%r11,%rdx), %rdx
	jmp	.L791
	.p2align 4,,10
.L1005:
	addq	$13, %rdx
	vcomiss	-13(%rdx), %xmm4
	jne	.L788
.L791:
	addl	$1, %eax
	cmpl	%ecx, %eax
	jne	.L1005
	jmp	.L788
.L1000:
	vmovss	12(%rbp), %xmm4
	movl	%r9d, 96(%rsp)
	jmp	.L883
.L812:
	cmpl	$1, %r8d
	je	.L1006
	movl	%r12d, 56(%rsp)
	movq	%rbp, %rdx
	movq	%rbx, %rcx
	movq	%r13, 48(%rsp)
	movq	168(%rbx), %rax
	movq	%rax, 40(%rsp)
	movq	160(%rbx), %rax
	movq	%rax, 32(%rsp)
	movq	152(%rbx), %r9
	call	_Z9findHitsBP17GumpSearchContextP4RectiPP5PointPiS6_S4_i
	jmp	.L988
.L811:
	vcvtsi2ss	100(%rsp), %xmm5, %xmm5
	vcomiss	%xmm3, %xmm5
	ja	.L812
	movslq	96(%rsp), %rax
	leaq	(%rax,%rax,2), %rdx
	leaq	(%rax,%rdx,4), %r10
	addq	16(%rbx), %r10
	cmpl	100(%rsp), %r12d
	jge	.L850
	movl	100(%rsp), %edx
	testl	%r12d, %r12d
	setg	%dil
	testl	%edx, %edx
	jle	.L935
	testb	%dil, %dil
	je	.L935
	movl	$-1, %eax
	movq	%r10, %rcx
	xorl	%esi, %esi
	movl	%eax, %ebx
	xorl	%r8d, %r8d
	movl	100(%rsp), %r11d
	jmp	.L860
	.p2align 4,,10
.L856:
	addl	$1, %r8d
	addq	$13, %rcx
	cmpl	%esi, %r12d
	jle	.L859
	cmpl	%r8d, %r11d
	jle	.L859
.L860:
	vmovss	5(%rcx), %xmm2
	movzbl	(%rcx), %r9d
	vcomiss	%xmm0, %xmm2
	movl	1(%rcx), %edx
	vmovss	9(%rcx), %xmm3
	jb	.L856
	vcomiss	%xmm2, %xmm1
	jb	.L856
	movslq	%esi, %rbp
	leaq	0(%rbp,%rbp,2), %r14
	leaq	0(%rbp,%r14,4), %rbp
	addq	%r13, %rbp
	cmpl	%ebx, %edx
	movb	%r9b, 0(%rbp)
	movl	%edx, 1(%rbp)
	vmovss	%xmm2, 5(%rbp)
	vmovss	%xmm3, 9(%rbp)
	jle	.L879
	movl	%esi, %eax
	movl	%edx, %ebx
.L879:
	addl	$1, %esi
	jmp	.L856
.L1006:
	movq	168(%rbx), %rax
	movq	152(%rbx), %rdx
	movl	(%rax), %eax
	movq	(%rdx), %rdx
	testl	%eax, %eax
	jle	.L901
	subl	$1, %eax
	leaq	(%rax,%rax,2), %rcx
	leaq	(%rax,%rcx,4), %rax
	leaq	13(%rdx,%rax), %rcx
	xorl	%eax, %eax
	.p2align 4,,10
.L823:
	vmovss	5(%rdx), %xmm3
	movzbl	(%rdx), %r9d
	vcomiss	%xmm0, %xmm3
	movl	1(%rdx), %r8d
	vmovss	9(%rdx), %xmm5
	jb	.L818
	vcomiss	%xmm3, %xmm1
	jb	.L818
	vcomiss	%xmm2, %xmm5
	jb	.L818
	vcomiss	%xmm5, %xmm4
	jb	.L818
	movslq	%eax, %r10
	addl	$1, %eax
	leaq	(%r10,%r10,2), %r11
	leaq	(%r10,%r11,4), %r10
	addq	%r13, %r10
	cmpl	%eax, %r12d
	movb	%r9b, (%r10)
	movl	%r8d, 1(%r10)
	vmovss	%xmm3, 5(%r10)
	vmovss	%xmm5, 9(%r10)
	je	.L988
	.p2align 4,,10
.L818:
	addq	$13, %rdx
	cmpq	%rcx, %rdx
	jne	.L823
	jmp	.L988
.L859:
	movl	%esi, %edx
.L853:
	cmpl	%r8d, 100(%rsp)
	jle	.L855
	leal	1(%r8), %ebp
	movslq	%r8d, %rcx
	movl	100(%rsp), %r14d
	leaq	(%rcx,%rcx,2), %r9
	leaq	(%rcx,%r9,4), %rcx
	addq	%rcx, %r10
	jmp	.L870
	.p2align 4,,10
.L865:
	movl	%ebp, %ecx
	addq	$13, %r10
	addl	$1, %ebp
	cmpl	%ecx, %r14d
	jle	.L855
.L870:
	movl	1(%r10), %ecx
	movzbl	(%r10), %r8d
	vmovss	5(%r10), %xmm2
	vmovss	9(%r10), %xmm3
	cmpl	%ebx, %ecx
	jg	.L865
	vcomiss	%xmm0, %xmm2
	jb	.L865
	vcomiss	%xmm2, %xmm1
	jb	.L865
	cltq
	leaq	(%rax,%rax,2), %r9
	leaq	(%rax,%r9,4), %rax
	addq	%r13, %rax
	testb	%dil, %dil
	movb	%r8b, (%rax)
	movl	%ecx, 1(%rax)
	vmovss	%xmm2, 5(%rax)
	vmovss	%xmm3, 9(%rax)
	je	.L905
	movl	$-1, %eax
	movq	%r13, %r11
	xorl	%ecx, %ecx
	movl	%eax, %r8d
	jmp	.L881
	.p2align 4,,10
.L868:
	movl	%ebx, %r8d
.L881:
	movl	1(%r11), %r9d
	movl	%r8d, %ebx
	cmpl	%r8d, %r9d
	cmovge	%r9d, %ebx
	cmovg	%ecx, %eax
	addl	$1, %ecx
	addq	$13, %r11
	cmpl	%ecx, %r12d
	jg	.L868
	jmp	.L865
.L850:
	movl	100(%rsp), %eax
	testl	%eax, %eax
	jle	.L991
	movl	124(%rsp), %eax
	movq	%r10, %rdx
	xorl	%esi, %esi
	leaq	(%rax,%rax,2), %rcx
	leaq	(%rax,%rcx,4), %rax
	leaq	13(%r10,%rax), %rax
.L875:
	vmovss	5(%rdx), %xmm2
	movzbl	(%rdx), %r8d
	vcomiss	%xmm0, %xmm2
	movl	1(%rdx), %ecx
	vmovss	9(%rdx), %xmm3
	jb	.L871
	vcomiss	%xmm2, %xmm1
	jb	.L871
	movslq	%esi, %r9
	addl	$1, %esi
	leaq	(%r9,%r9,2), %r10
	leaq	(%r9,%r10,4), %r9
	addq	%r13, %r9
	movb	%r8b, (%r9)
	movl	%ecx, 1(%r9)
	vmovss	%xmm2, 5(%r9)
	vmovss	%xmm3, 9(%r9)
.L871:
	addq	$13, %rdx
	cmpq	%rax, %rdx
	jne	.L875
	movl	%esi, %edx
.L855:
	movq	%r13, %rcx
	call	_Z8ranksortP5Pointj
	movl	%esi, %eax
	jmp	.L988
.L833:
	movl	%esi, %edx
.L827:
	cmpl	%r8d, 84(%rsp)
	jle	.L855
	leal	1(%r8), %ebp
	movslq	%r8d, %rcx
	movl	84(%rsp), %r14d
	leaq	(%rcx,%rcx,2), %r9
	leaq	(%rcx,%r9,4), %rcx
	addq	%rcx, %r10
	jmp	.L844
	.p2align 4,,10
.L839:
	movl	%ebp, %ecx
	addq	$13, %r10
	addl	$1, %ebp
	cmpl	%ecx, %r14d
	jle	.L855
.L844:
	movl	1(%r10), %ecx
	movzbl	(%r10), %r8d
	vmovss	5(%r10), %xmm1
	vmovss	9(%r10), %xmm0
	cmpl	%ebx, %ecx
	jg	.L839
	vcomiss	%xmm2, %xmm0
	jb	.L839
	vcomiss	%xmm0, %xmm4
	jb	.L839
	cltq
	leaq	(%rax,%rax,2), %r9
	leaq	(%rax,%r9,4), %rax
	addq	%r13, %rax
	testb	%dil, %dil
	movb	%r8b, (%rax)
	movl	%ecx, 1(%rax)
	vmovss	%xmm1, 5(%rax)
	vmovss	%xmm0, 9(%rax)
	je	.L903
	movl	$-1, %eax
	movq	%r13, %r11
	xorl	%ecx, %ecx
	movl	%eax, %r8d
	jmp	.L878
	.p2align 4,,10
.L842:
	movl	%ebx, %r8d
.L878:
	movl	1(%r11), %r9d
	movl	%r8d, %ebx
	cmpl	%r8d, %r9d
	cmovge	%r9d, %ebx
	cmovg	%ecx, %eax
	addl	$1, %ecx
	addq	$13, %r11
	cmpl	%ecx, %r12d
	jg	.L842
	jmp	.L839
.L824:
	movl	84(%rsp), %ecx
	testl	%ecx, %ecx
	jle	.L991
	movl	92(%rsp), %eax
	movq	%r10, %rdx
	xorl	%esi, %esi
	leaq	(%rax,%rax,2), %rcx
	leaq	(%rax,%rcx,4), %rax
	leaq	13(%r10,%rax), %rax
.L849:
	vmovss	9(%rdx), %xmm0
	movzbl	(%rdx), %r8d
	vcomiss	%xmm2, %xmm0
	movl	1(%rdx), %ecx
	vmovss	5(%rdx), %xmm1
	jb	.L845
	vcomiss	%xmm0, %xmm4
	jb	.L845
	movslq	%esi, %r9
	addl	$1, %esi
	leaq	(%r9,%r9,2), %r10
	leaq	(%r9,%r10,4), %r9
	addq	%r13, %r9
	movb	%r8b, (%r9)
	movl	%ecx, 1(%r9)
	vmovss	%xmm1, 5(%r9)
	vmovss	%xmm0, 9(%r9)
.L845:
	addq	$13, %rdx
	cmpq	%rax, %rdx
	jne	.L849
	movl	%esi, %edx
	jmp	.L855
.L991:
	xorl	%edx, %edx
	xorl	%esi, %esi
	jmp	.L855
.L931:
	movl	$-1, %eax
	xorl	%edx, %edx
	xorl	%esi, %esi
	movl	%eax, %ebx
	xorl	%r8d, %r8d
	jmp	.L827
.L935:
	movl	$-1, %eax
	xorl	%edx, %edx
	xorl	%esi, %esi
	movl	%eax, %ebx
	xorl	%r8d, %r8d
	jmp	.L853
.L903:
	orl	$-1, %eax
	movl	%eax, %ebx
	jmp	.L839
.L905:
	orl	$-1, %eax
	movl	%eax, %ebx
	jmp	.L865
	.seh_endproc
	.p2align 4,,15
	.globl	_Z11buildPointsi
	.def	_Z11buildPointsi;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z11buildPointsi
_Z11buildPointsi:
.LFB77:
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movslq	%ecx, %rsi
	movl	$40, %ecx
	call	malloc
	movq	%rsi, %rcx
	movl	$1, %edx
	movl	%esi, (%rax)
	movq	%rax, %rbx
	call	calloc
	movq	%rsi, %rcx
	movl	$4, %edx
	movq	%rax, 8(%rbx)
	call	calloc
	movq	%rsi, %rcx
	movl	$4, %edx
	movq	%rax, 16(%rbx)
	call	calloc
	movl	$4, %edx
	movq	%rsi, %rcx
	movq	%rax, 24(%rbx)
	call	calloc
	movq	%rax, 32(%rbx)
	movq	%rbx, %rax
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z10copyPointsP6Points
	.def	_Z10copyPointsP6Points;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10copyPointsP6Points
_Z10copyPointsP6Points:
.LFB78:
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	movq	%rcx, %rdi
	movl	$40, %ecx
	call	malloc
	movslq	(%rdi), %rsi
	movl	$1, %edx
	movq	%rax, %rbx
	movq	%rsi, %rcx
	movl	%esi, (%rax)
	call	calloc
	movq	%rsi, %rcx
	movl	$4, %edx
	movq	%rax, %r13
	movq	%rax, 8(%rbx)
	call	calloc
	movq	%rsi, %rcx
	movl	$4, %edx
	movq	%rax, %r12
	movq	%rax, 16(%rbx)
	call	calloc
	movq	%rsi, %rcx
	movl	$4, %edx
	movq	%rax, %rbp
	movq	%rax, 24(%rbx)
	call	calloc
	movq	8(%rdi), %rdx
	movq	%rsi, %r8
	movq	%r13, %rcx
	movq	%rax, 32(%rbx)
	salq	$2, %rsi
	call	memcpy
	movq	16(%rdi), %rdx
	movq	%rsi, %r8
	movq	%r12, %rcx
	call	memcpy
	movq	24(%rdi), %rdx
	movq	%rsi, %r8
	movq	%rbp, %rcx
	call	memcpy
	movslq	(%rbx), %r8
	movq	32(%rbx), %rcx
	movq	32(%rdi), %rdx
	salq	$2, %r8
	call	memcpy
	movq	%rbx, %rax
	addq	$40, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z10fillPointsP6PointsP5Pointi
	.def	_Z10fillPointsP6PointsP5Pointi;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10fillPointsP6PointsP5Pointi
_Z10fillPointsP6PointsP5Pointi:
.LFB79:
	.seh_endprologue
	xorl	%eax, %eax
	testl	%r8d, %r8d
	jle	.L1015
	.p2align 4,,10
.L1014:
	movzbl	(%rdx), %r10d
	addq	$13, %rdx
	movq	8(%rcx), %r9
	movb	%r10b, (%r9,%rax)
	movl	-12(%rdx), %r10d
	movq	16(%rcx), %r9
	movl	%r10d, (%r9,%rax,4)
	movq	24(%rcx), %r9
	vmovss	-8(%rdx), %xmm0
	vmovss	%xmm0, (%r9,%rax,4)
	movq	32(%rcx), %r9
	vmovss	-4(%rdx), %xmm0
	vmovss	%xmm0, (%r9,%rax,4)
	addq	$1, %rax
	cmpl	%eax, %r8d
	jg	.L1014
.L1015:
	rep ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z12fillPointArrP5PointP6Points
	.def	_Z12fillPointArrP5PointP6Points;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z12fillPointArrP5PointP6Points
_Z12fillPointArrP5PointP6Points:
.LFB80:
	.seh_endprologue
	xorl	%eax, %eax
	movl	(%rdx), %r8d
	testl	%r8d, %r8d
	jle	.L1021
	.p2align 4,,10
.L1020:
	movq	8(%rdx), %r8
	addq	$13, %rcx
	movzbl	(%r8,%rax), %r8d
	movb	%r8b, -13(%rcx)
	movq	16(%rdx), %r8
	movl	(%r8,%rax,4), %r8d
	movl	%r8d, -12(%rcx)
	movq	24(%rdx), %r8
	vmovss	(%r8,%rax,4), %xmm0
	vmovss	%xmm0, -8(%rcx)
	movq	32(%rdx), %r8
	vmovss	(%r8,%rax,4), %xmm0
	leal	1(%rax), %r8d
	addq	$1, %rax
	vmovss	%xmm0, -4(%rcx)
	cmpl	%r8d, (%rdx)
	jg	.L1020
.L1021:
	rep ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z10freePointsP6Points
	.def	_Z10freePointsP6Points;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10freePointsP6Points
_Z10freePointsP6Points:
.LFB81:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	movq	%rcx, %rbx
	movq	8(%rcx), %rcx
	call	free
	movq	16(%rbx), %rcx
	call	free
	movq	24(%rbx), %rcx
	call	free
	movq	32(%rbx), %rcx
	call	free
	movq	%rbx, %rcx
	addq	$32, %rsp
	popq	%rbx
	jmp	free
	.seh_endproc
	.p2align 4,,15
	.globl	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	.def	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i:
.LFB82:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$264, %rsp
	.seh_stackalloc	264
	vmovaps	%xmm6, 144(%rsp)
	.seh_savexmm	%xmm6, 144
	vmovaps	%xmm7, 160(%rsp)
	.seh_savexmm	%xmm7, 160
	vmovaps	%xmm8, 176(%rsp)
	.seh_savexmm	%xmm8, 176
	vmovaps	%xmm9, 192(%rsp)
	.seh_savexmm	%xmm9, 192
	vmovaps	%xmm10, 208(%rsp)
	.seh_savexmm	%xmm10, 208
	vmovaps	%xmm11, 224(%rsp)
	.seh_savexmm	%xmm11, 224
	vmovaps	%xmm12, 240(%rsp)
	.seh_savexmm	%xmm12, 240
	.seh_endprologue
	addl	$1, regions(%rip)
	movq	%rcx, %rdi
	movl	$88, %ecx
	movq	%rdx, %r12
	movq	%r8, 96(%rsp)
	movq	%r9, 104(%rsp)
	call	malloc
	cmpl	$7, 400(%rsp)
	movq	%rax, %rbp
	movq	%r12, 24(%rax)
	movq	$0, 32(%rax)
	movq	$0, 40(%rax)
	movq	$0, 48(%rax)
	movq	$0, 56(%rax)
	movq	$0, 64(%rax)
	movq	$0, 72(%rax)
	movq	$0, 80(%rax)
	movq	$0, 8(%rax)
	jle	.L1024
	movq	120(%rdi), %rax
	vmovss	(%r12), %xmm6
	vmovsd	136(%rdi), %xmm2
	vmovss	4(%r12), %xmm5
	vmovss	(%rax), %xmm4
	vmovss	4(%rax), %xmm1
	xorl	%eax, %eax
	vsubss	%xmm4, %xmm6, %xmm8
	vmovss	8(%r12), %xmm3
	vmovsd	144(%rdi), %xmm0
	vsubss	%xmm4, %xmm3, %xmm4
	vmovss	12(%r12), %xmm7
	vunpcklps	%xmm8, %xmm8, %xmm8
	vcvtps2pd	%xmm8, %xmm8
	vdivsd	%xmm2, %xmm8, %xmm8
	movq	96(%rdi), %r11
	vunpcklps	%xmm4, %xmm4, %xmm4
	vcvtps2pd	%xmm4, %xmm4
	vdivsd	%xmm2, %xmm4, %xmm2
	vroundsd	$1, %xmm8, %xmm8, %xmm8
	vcvttsd2si	%xmm8, %r8d
	vsubss	%xmm1, %xmm5, %xmm8
	vsubss	%xmm1, %xmm7, %xmm1
	vunpcklps	%xmm8, %xmm8, %xmm8
	vcvtps2pd	%xmm8, %xmm8
	testl	%r8d, %r8d
	vunpcklps	%xmm1, %xmm1, %xmm1
	vcvtps2pd	%xmm1, %xmm1
	cmovs	%eax, %r8d
	movslq	%r8d, %r10
	leaq	0(,%r10,8), %rbx
	vdivsd	%xmm0, %xmm8, %xmm8
	vroundsd	$2, %xmm2, %xmm2, %xmm2
	vcvttsd2si	%xmm2, %ecx
	vdivsd	%xmm0, %xmm1, %xmm0
	vroundsd	$1, %xmm8, %xmm8, %xmm8
	vcvttsd2si	%xmm8, %edx
	testl	%edx, %edx
	cmovs	%eax, %edx
	cmpl	$150, %ecx
	movb	$-106, %al
	cmovg	%eax, %ecx
	subl	%r8d, %ecx
	vroundsd	$2, %xmm0, %xmm0, %xmm0
	vcvttsd2si	%xmm0, %r9d
	cmpl	$150, %r9d
	cmovle	%r9d, %eax
	movslq	%edx, %r9
	salq	$4, %r9
	movq	%r9, %rsi
	subl	%edx, %eax
	addq	(%r11,%r10,8), %rsi
	vcomiss	(%rsi), %xmm6
	movq	%rsi, %r10
	jae	.L1025
	movq	%r9, %r10
	subl	$1, %r8d
	addq	-8(%r11,%rbx), %r10
.L1025:
	xorl	%r9d, %r9d
	vcomiss	4(%r10), %xmm5
	setb	%r9b
	subl	%r9d, %edx
	testl	%ecx, %ecx
	jle	.L1029
	movslq	%edx, %rdx
	movslq	%r8d, %r8
	subl	$1, %ecx
	leaq	0(,%r8,8), %rsi
	movq	%rbp, 112(%rsp)
	xorl	%r13d, %r13d
	leaq	1(%r8,%rcx), %r8
	movq	%rdx, %rcx
	movq	%r12, 120(%rsp)
	salq	$4, %rcx
	salq	$3, %r8
	movl	$100000, 92(%rsp)
	leaq	0(,%rdx,4), %r15
	movq	%rcx, %rbx
	vxorps	%xmm11, %xmm11, %xmm11
	leaq	0(,%rdx,8), %rcx
	movq	%rbx, %rbp
	movq	%rcx, 80(%rsp)
	leal	-1(%rax), %ecx
	leaq	1(%rdx,%rcx), %rcx
	salq	$2, %rcx
	.p2align 4,,10
.L1030:
	testl	%eax, %eax
	jle	.L1038
	movq	80(%rsp), %r10
	movq	%rbp, %r9
	movq	%r15, %rdx
	.p2align 4,,10
.L1039:
	movq	112(%rdi), %r11
	movq	(%r11,%rsi), %r11
	movl	(%r11,%rdx), %r11d
	testl	%r11d, %r11d
	je	.L1031
	movq	104(%rdi), %rbx
	movq	%r9, %r14
	addq	(%rbx,%rsi), %r14
	vmovss	8(%r14), %xmm0
	vcomiss	%xmm6, %xmm0
	jb	.L1031
	vmovss	(%r14), %xmm1
	vcomiss	%xmm1, %xmm3
	jb	.L1031
	vmovss	12(%r14), %xmm2
	vcomiss	%xmm5, %xmm2
	jb	.L1031
	vmovss	4(%r14), %xmm4
	vcomiss	%xmm4, %xmm7
	jb	.L1031
	vminss	%xmm7, %xmm2, %xmm9
	movq	80(%rdi), %r12
	xorl	%ebx, %ebx
	vmaxss	%xmm5, %xmm4, %xmm10
	vminss	%xmm3, %xmm0, %xmm8
	vsubss	%xmm4, %xmm2, %xmm2
	vsubss	%xmm10, %xmm9, %xmm9
	movq	(%r12,%rsi), %r12
	vmaxss	%xmm6, %xmm1, %xmm10
	vsubss	%xmm1, %xmm0, %xmm1
	vsubss	%xmm10, %xmm8, %xmm8
	movq	(%r12,%r10), %r14
	vmulss	%xmm1, %xmm2, %xmm0
	movq	152(%rdi), %r12
	vmulss	%xmm8, %xmm9, %xmm8
	vdivss	%xmm0, %xmm8, %xmm8
	vcomiss	%xmm11, %xmm8
	setne	%bl
	imull	%r11d, %ebx
	addl	%ebx, 92(%rsp)
	movslq	%r13d, %rbx
	addl	$1, %r13d
	movq	%r14, (%r12,%rbx,8)
	movq	160(%rdi), %r12
	movl	$0, (%r12,%rbx,4)
	movq	168(%rdi), %r12
	movl	%r11d, (%r12,%rbx,4)
	.p2align 4,,10
.L1031:
	addq	$4, %rdx
	addq	$16, %r9
	addq	$8, %r10
	cmpq	%rcx, %rdx
	jne	.L1039
.L1038:
	addq	$8, %rsi
	cmpq	%r8, %rsi
	jne	.L1030
	movq	112(%rsp), %rbp
	movl	$13, %edx
	movl	$500, %ecx
	cmpl	$99999, 92(%rsp)
	movq	120(%rsp), %r12
	setle	%sil
	cmpl	$9, 400(%rsp)
	sete	%al
	orl	%eax, %esi
	call	calloc
	testl	%r13d, %r13d
	movq	%rax, 8(%rbp)
	je	.L1040
	cmpl	$1, %r13d
	je	.L1086
	movq	%rax, 48(%rsp)
	movq	168(%rdi), %rax
	movl	%r13d, %r8d
	movq	152(%rdi), %r9
	movq	%r12, %rdx
	movq	%rdi, %rcx
	movl	$500, 56(%rsp)
	movq	%rax, 40(%rsp)
	movq	160(%rdi), %rax
	movq	%rax, 32(%rsp)
	call	_Z9findHitsBP17GumpSearchContextP4RectiPP5PointPiS6_S4_i
	movl	%eax, 0(%rbp)
.L1049:
	testb	%sil, %sil
	je	.L1087
.L1085:
	vmovaps	144(%rsp), %xmm6
	movq	%rbp, %rax
	vmovaps	160(%rsp), %xmm7
	vmovaps	176(%rsp), %xmm8
	vmovaps	192(%rsp), %xmm9
	vmovaps	208(%rsp), %xmm10
	vmovaps	224(%rsp), %xmm11
	vmovaps	240(%rsp), %xmm12
	addq	$264, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L1024:
	movl	$13, %edx
	movl	$500, %ecx
	xorl	%esi, %esi
	call	calloc
	movq	%rax, 8(%rbp)
.L1040:
	movq	(%r12), %rcx
	leaq	128(%rsp), %rdx
	movq	%rax, %r9
	movq	8(%r12), %rbx
	movl	$500, %r8d
	movq	%rcx, 128(%rsp)
	movq	%rdi, %rcx
	movq	%rbx, 136(%rsp)
	call	_Z12searchBinaryP17GumpSearchContext4RectiP5Point
	testb	%sil, %sil
	movl	%eax, 0(%rbp)
	jne	.L1085
.L1087:
	vmovss	(%r12), %xmm11
	movl	$16, %edx
	movl	$6, %ecx
	vmovss	8(%r12), %xmm12
	vmovss	.LC1(%rip), %xmm6
	vaddss	%xmm11, %xmm12, %xmm8
	vmovss	4(%r12), %xmm10
	vmovss	12(%r12), %xmm9
	vmulss	%xmm6, %xmm8, %xmm8
	vaddss	%xmm10, %xmm9, %xmm7
	vmulss	%xmm6, %xmm7, %xmm7
	call	calloc
	movq	96(%rsp), %rdx
	vmovss	%xmm11, (%rax)
	vaddss	%xmm11, %xmm8, %xmm11
	vmovss	%xmm8, 8(%rax)
	vmovss	%xmm10, 4(%rax)
	vmovss	8(%r12), %xmm0
	vaddss	%xmm10, %xmm7, %xmm10
	vmulss	%xmm6, %xmm11, %xmm11
	vmovss	%xmm9, 12(%rax)
	vmovss	4(%r12), %xmm3
	vmovss	12(%r12), %xmm2
	vmovss	%xmm8, 16(%rax)
	vaddss	%xmm12, %xmm8, %xmm8
	vmulss	%xmm6, %xmm10, %xmm10
	testq	%rdx, %rdx
	movq	%rax, 32(%rbp)
	vmovss	%xmm0, 24(%rax)
	vmovss	%xmm11, 32(%rax)
	vmulss	%xmm6, %xmm8, %xmm8
	vmovss	(%r12), %xmm1
	vmovss	%xmm7, 60(%rax)
	vmovss	%xmm7, 68(%rax)
	vaddss	%xmm9, %xmm7, %xmm7
	vmovss	%xmm3, 20(%rax)
	vmovss	%xmm2, 28(%rax)
	vmulss	%xmm6, %xmm7, %xmm7
	vmovss	%xmm8, 40(%rax)
	vmovss	%xmm3, 36(%rax)
	vmovss	%xmm2, 44(%rax)
	vmovss	%xmm1, 48(%rax)
	vmovss	%xmm0, 56(%rax)
	vmovss	%xmm3, 52(%rax)
	vmovss	%xmm1, 64(%rax)
	vmovss	%xmm0, 72(%rax)
	vmovss	%xmm2, 76(%rax)
	vmovss	%xmm1, 80(%rax)
	vmovss	%xmm0, 88(%rax)
	vmovss	%xmm10, 84(%rax)
	vmovss	%xmm7, 92(%rax)
	je	.L1088
.L1051:
	movq	368(%rsp), %rax
	movq	%rdx, 40(%rbp)
	testq	%rax, %rax
	je	.L1089
.L1052:
	movq	104(%rsp), %rdx
	movq	%rax, 48(%rbp)
	testq	%rdx, %rdx
	je	.L1090
.L1053:
	movq	376(%rsp), %rax
	movq	%rdx, 56(%rbp)
	testq	%rax, %rax
	je	.L1091
.L1054:
	movq	392(%rsp), %rcx
	movq	%rax, 64(%rbp)
	testq	%rcx, %rcx
	je	.L1092
.L1055:
	movq	384(%rsp), %rax
	movq	%rcx, 72(%rbp)
	testq	%rax, %rax
	je	.L1093
.L1056:
	movq	%rax, 80(%rbp)
	jmp	.L1085
.L1086:
	movq	168(%rdi), %rdx
	movl	(%rdx), %ecx
	movq	152(%rdi), %rdx
	testl	%ecx, %ecx
	movq	(%rdx), %rdx
	jle	.L1057
	subl	$1, %ecx
	xorl	%r9d, %r9d
	leaq	(%rcx,%rcx,2), %r8
	leaq	(%rcx,%r8,4), %rcx
	leaq	13(%rdx,%rcx), %r10
	jmp	.L1048
	.p2align 4,,10
.L1094:
	vmovss	(%r12), %xmm6
.L1048:
	vmovss	5(%rdx), %xmm0
	movzbl	(%rdx), %r8d
	vcomiss	%xmm6, %xmm0
	movl	1(%rdx), %ecx
	vmovss	9(%rdx), %xmm1
	jb	.L1043
	vcomiss	8(%r12), %xmm0
	ja	.L1043
	vcomiss	4(%r12), %xmm1
	jb	.L1043
	vcomiss	12(%r12), %xmm1
	ja	.L1043
	movslq	%r9d, %r11
	addl	$1, %r9d
	leaq	(%r11,%r11,2), %rbx
	leaq	(%r11,%rbx,4), %r11
	addq	%rax, %r11
	cmpl	$500, %r9d
	movb	%r8b, (%r11)
	movl	%ecx, 1(%r11)
	vmovss	%xmm0, 5(%r11)
	vmovss	%xmm1, 9(%r11)
	je	.L1042
	.p2align 4,,10
.L1043:
	addq	$13, %rdx
	cmpq	%r10, %rdx
	jne	.L1094
.L1042:
	movl	%r9d, 0(%rbp)
	jmp	.L1049
.L1029:
	cmpl	$9, 400(%rsp)
	movl	$13, %edx
	movl	$500, %ecx
	sete	%sil
	call	calloc
	movq	%rax, 8(%rbp)
	jmp	.L1040
.L1093:
	movq	56(%rbp), %rax
	movq	80(%rax), %r9
	movq	40(%rbp), %rax
	movq	80(%rax), %r8
	movq	32(%rbp), %rax
	leaq	80(%rax), %rdx
	movl	400(%rsp), %eax
	addl	$1, %eax
	movl	%eax, 64(%rsp)
	movq	64(%rcx), %rax
	movq	%rdi, %rcx
	movq	$0, 48(%rsp)
	movq	%rax, 56(%rsp)
	movq	64(%rbp), %rax
	movq	72(%rax), %rax
	movq	%rax, 40(%rsp)
	movq	48(%rbp), %rax
	movq	80(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	jmp	.L1056
.L1088:
	movl	400(%rsp), %ecx
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	movq	$0, 32(%rsp)
	leal	1(%rcx), %edx
	movq	%rdi, %rcx
	movl	%edx, 64(%rsp)
	movq	%rax, %rdx
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movq	%rax, %rdx
	jmp	.L1051
.L1089:
	movq	32(%rbp), %rax
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movq	$0, 56(%rsp)
	movq	%rdi, %rcx
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	movq	$0, 32(%rsp)
	leaq	16(%rax), %rdx
	movl	400(%rsp), %eax
	addl	$1, %eax
	movl	%eax, 64(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	jmp	.L1052
.L1090:
	movq	40(%rbp), %rdx
	xorl	%r9d, %r9d
	movq	32(%rbp), %rcx
	movq	48(%rdx), %r8
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	leaq	32(%rcx), %rdx
	movl	400(%rsp), %ecx
	movq	$0, 40(%rsp)
	addl	$1, %ecx
	movl	%ecx, 64(%rsp)
	movq	%rdi, %rcx
	movq	40(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movq	%rax, %rdx
	jmp	.L1053
.L1091:
	movq	40(%rbp), %rax
	movq	%rdi, %rcx
	movq	64(%rdx), %r9
	movq	64(%rax), %r8
	movq	32(%rbp), %rax
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	leaq	48(%rax), %rdx
	movl	400(%rsp), %eax
	addl	$1, %eax
	movl	%eax, 64(%rsp)
	movq	48(%rbp), %rax
	movq	64(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	jmp	.L1054
.L1092:
	movq	56(%rbp), %rax
	movq	%rdi, %rcx
	movq	72(%rax), %r9
	movq	40(%rbp), %rax
	movq	72(%rax), %r8
	movq	32(%rbp), %rax
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	leaq	64(%rax), %rdx
	movl	400(%rsp), %eax
	addl	$1, %eax
	movl	%eax, 64(%rsp)
	movq	48(%rbp), %rax
	movq	72(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movq	%rax, %rcx
	jmp	.L1055
.L1057:
	xorl	%r9d, %r9d
	jmp	.L1042
	.seh_endproc
	.p2align 4,,15
	.globl	_Z13convertRegionP6Regionbbbbbb
	.def	_Z13convertRegionP6Regionbbbbbb;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z13convertRegionP6Regionbbbbbb
_Z13convertRegionP6Regionbbbbbb:
.LFB83:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$88, %rsp
	.seh_stackalloc	88
	.seh_endprologue
	movl	200(%rsp), %eax
	movq	%rcx, %r14
	movl	%r8d, %ebp
	movl	(%rcx), %ebx
	movl	$40, %ecx
	movl	%r9d, %r12d
	movl	%edx, %r13d
	movl	192(%rsp), %edi
	movl	%eax, 64(%rsp)
	movl	208(%rsp), %eax
	movslq	%ebx, %r15
	movl	%eax, 68(%rsp)
	call	malloc
	movl	$1, %edx
	movq	%r15, %rcx
	movl	%ebx, (%rax)
	movq	%rax, %rsi
	call	calloc
	movl	$4, %edx
	movq	%r15, %rcx
	movq	%rax, 8(%rsi)
	movq	%rax, 72(%rsp)
	call	calloc
	movl	$4, %edx
	movq	%r15, %rcx
	movq	%rax, 16(%rsi)
	call	calloc
	movq	%r15, %rcx
	movl	$4, %edx
	movq	%rax, 24(%rsi)
	call	calloc
	testl	%ebx, %ebx
	movq	%rsi, 16(%r14)
	movq	%rax, 32(%rsi)
	movq	8(%r14), %rcx
	jle	.L1096
	movq	72(%rsp), %r10
	movq	%rcx, %r11
	movq	%r10, %rax
	xorl	%r10d, %r10d
	jmp	.L1098
	.p2align 4,,10
.L1124:
	movq	8(%rsi), %rax
.L1098:
	movzbl	(%r11), %edx
	addq	$13, %r11
	movb	%dl, (%rax,%r10)
	movl	-12(%r11), %edx
	movq	16(%rsi), %rax
	movl	%edx, (%rax,%r10,4)
	movq	24(%rsi), %rax
	vmovss	-8(%r11), %xmm0
	vmovss	%xmm0, (%rax,%r10,4)
	movq	32(%rsi), %rax
	vmovss	-4(%r11), %xmm0
	vmovss	%xmm0, (%rax,%r10,4)
	addq	$1, %r10
	cmpl	%r10d, %ebx
	jg	.L1124
	movq	8(%r14), %rcx
.L1096:
	call	free
	testb	%r13b, %r13b
	movq	$0, 8(%r14)
	je	.L1099
	movq	40(%r14), %rcx
	testq	%rcx, %rcx
	je	.L1099
	movl	$1, 48(%rsp)
	movl	$1, %r9d
	movl	$1, %r8d
	movl	$1, 40(%rsp)
	movl	$1, %edx
	movl	$1, 32(%rsp)
	call	_Z13convertRegionP6Regionbbbbbb
.L1099:
	testb	%r12b, %r12b
	je	.L1100
	movq	48(%r14), %rcx
	testq	%rcx, %rcx
	je	.L1100
	movl	$1, 48(%rsp)
	movl	$1, %r9d
	movl	$1, %r8d
	movl	$1, 40(%rsp)
	movl	$1, %edx
	movl	$1, 32(%rsp)
	call	_Z13convertRegionP6Regionbbbbbb
.L1100:
	testb	%bpl, %bpl
	je	.L1101
	movq	56(%r14), %rcx
	testq	%rcx, %rcx
	je	.L1101
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	movl	$1, 40(%rsp)
	movl	$1, %r8d
	movl	$1, 32(%rsp)
	call	_Z13convertRegionP6Regionbbbbbb
.L1101:
	testb	%dil, %dil
	je	.L1102
	movq	64(%r14), %rcx
	testq	%rcx, %rcx
	je	.L1102
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z13convertRegionP6Regionbbbbbb
.L1102:
	cmpb	$0, 68(%rsp)
	je	.L1103
	movq	72(%r14), %rcx
	testq	%rcx, %rcx
	je	.L1103
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z13convertRegionP6Regionbbbbbb
.L1103:
	cmpb	$0, 64(%rsp)
	je	.L1123
	movq	80(%r14), %rcx
	testq	%rcx, %rcx
	je	.L1123
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	movl	$0, 208(%rsp)
	movl	$1, 200(%rsp)
	movl	$0, 192(%rsp)
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	_Z13convertRegionP6Regionbbbbbb
	.p2align 4,,10
.L1123:
	addq	$88, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	_Z10freeRegionP6Regionbbbbbb
	.def	_Z10freeRegionP6Regionbbbbbb;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z10freeRegionP6Regionbbbbbb
_Z10freeRegionP6Regionbbbbbb:
.LFB84:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	testb	%dl, %dl
	movq	%rcx, %rbx
	movl	%r8d, %r14d
	movl	%r9d, %r15d
	movl	176(%rsp), %r13d
	movl	184(%rsp), %ebp
	movl	192(%rsp), %r12d
	je	.L1126
	movq	40(%rcx), %rsi
	testq	%rsi, %rsi
	je	.L1126
	movq	40(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1127
	movl	$1, 48(%rsp)
	movl	$1, %r9d
	movl	$1, %r8d
	movl	$1, 40(%rsp)
	movl	$1, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1127:
	movq	48(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1128
	movl	$1, 48(%rsp)
	movl	$1, %r9d
	movl	$1, %r8d
	movl	$1, 40(%rsp)
	movl	$1, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1128:
	movq	56(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1129
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	movl	$1, 40(%rsp)
	movl	$1, %r8d
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1129:
	movq	64(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1130
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1130:
	movq	72(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1131
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1131:
	movq	80(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1132
	movl	$0, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$0, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1132:
	movq	32(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1133
	call	free
.L1133:
	movq	16(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L1134
	movq	8(%rdi), %rcx
	call	free
	movq	16(%rdi), %rcx
	call	free
	movq	24(%rdi), %rcx
	call	free
	movq	32(%rdi), %rcx
	call	free
	movq	%rdi, %rcx
	call	free
.L1134:
	movq	%rsi, %rcx
	call	free
.L1126:
	testb	%r15b, %r15b
	je	.L1135
	movq	48(%rbx), %rsi
	testq	%rsi, %rsi
	je	.L1135
	movq	40(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1136
	movl	$1, 48(%rsp)
	movl	$1, %r9d
	movl	$1, %r8d
	movl	$1, 40(%rsp)
	movl	$1, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1136:
	movq	48(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1137
	movl	$1, 48(%rsp)
	movl	$1, %r9d
	movl	$1, %r8d
	movl	$1, 40(%rsp)
	movl	$1, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1137:
	movq	56(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1138
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	movl	$1, 40(%rsp)
	movl	$1, %r8d
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1138:
	movq	64(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1139
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1139:
	movq	72(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1140
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1140:
	movq	80(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1141
	movl	$0, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$0, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1141:
	movq	32(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1142
	call	free
.L1142:
	movq	16(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L1143
	movq	8(%rdi), %rcx
	call	free
	movq	16(%rdi), %rcx
	call	free
	movq	24(%rdi), %rcx
	call	free
	movq	32(%rdi), %rcx
	call	free
	movq	%rdi, %rcx
	call	free
.L1143:
	movq	%rsi, %rcx
	call	free
.L1135:
	testb	%r14b, %r14b
	je	.L1144
	movq	56(%rbx), %rsi
	testq	%rsi, %rsi
	je	.L1144
	movq	56(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1145
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%edx, %edx
	movl	$1, 40(%rsp)
	movl	$1, %r8d
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1145:
	movq	64(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1146
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1146:
	movq	72(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1147
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1147:
	movq	80(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1148
	movl	$0, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$0, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1148:
	movq	32(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1149
	call	free
.L1149:
	movq	16(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L1150
	movq	8(%rdi), %rcx
	call	free
	movq	16(%rdi), %rcx
	call	free
	movq	24(%rdi), %rcx
	call	free
	movq	32(%rdi), %rcx
	call	free
	movq	%rdi, %rcx
	call	free
.L1150:
	movq	%rsi, %rcx
	call	free
.L1144:
	testb	%r13b, %r13b
	je	.L1151
	movq	64(%rbx), %rsi
	testq	%rsi, %rsi
	je	.L1151
	movq	64(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1152
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1152:
	movq	72(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1153
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1153:
	movq	80(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1154
	movl	$0, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$0, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1154:
	movq	32(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1155
	call	free
.L1155:
	movq	16(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L1156
	movq	8(%rdi), %rcx
	call	free
	movq	16(%rdi), %rcx
	call	free
	movq	24(%rdi), %rcx
	call	free
	movq	32(%rdi), %rcx
	call	free
	movq	%rdi, %rcx
	call	free
.L1156:
	movq	%rsi, %rcx
	call	free
.L1151:
	testb	%r12b, %r12b
	je	.L1157
	movq	72(%rbx), %rsi
	testq	%rsi, %rsi
	je	.L1157
	movq	64(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1158
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1158:
	movq	72(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1159
	movl	$1, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1159:
	movq	80(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1160
	movl	$0, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$0, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1160:
	movq	32(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1161
	call	free
.L1161:
	movq	16(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L1162
	movq	8(%rdi), %rcx
	call	free
	movq	16(%rdi), %rcx
	call	free
	movq	24(%rdi), %rcx
	call	free
	movq	32(%rdi), %rcx
	call	free
	movq	%rdi, %rcx
	call	free
.L1162:
	movq	%rsi, %rcx
	call	free
.L1157:
	testb	%bpl, %bpl
	je	.L1163
	movq	80(%rbx), %rsi
	testq	%rsi, %rsi
	je	.L1163
	movq	80(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1164
	movl	$0, 48(%rsp)
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, 40(%rsp)
	xorl	%edx, %edx
	movl	$0, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
.L1164:
	movq	32(%rsi), %rcx
	testq	%rcx, %rcx
	je	.L1165
	call	free
.L1165:
	movq	16(%rsi), %rdi
	testq	%rdi, %rdi
	je	.L1166
	movq	8(%rdi), %rcx
	call	free
	movq	16(%rdi), %rcx
	call	free
	movq	24(%rdi), %rcx
	call	free
	movq	32(%rdi), %rcx
	call	free
	movq	%rdi, %rcx
	call	free
.L1166:
	movq	%rsi, %rcx
	call	free
.L1163:
	movq	32(%rbx), %rcx
	testq	%rcx, %rcx
	je	.L1167
	call	free
.L1167:
	movq	16(%rbx), %rsi
	testq	%rsi, %rsi
	je	.L1168
	movq	8(%rsi), %rcx
	call	free
	movq	16(%rsi), %rcx
	call	free
	movq	24(%rsi), %rcx
	call	free
	movq	32(%rsi), %rcx
	call	free
	movq	%rsi, %rcx
	call	free
.L1168:
	movq	%rbx, %rcx
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	free
	.seh_endproc
	.p2align 4,,15
	.globl	_Z9buildGridP17GumpSearchContext
	.def	_Z9buildGridP17GumpSearchContext;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z9buildGridP17GumpSearchContext
_Z9buildGridP17GumpSearchContext:
.LFB85:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$136, %rsp
	.seh_stackalloc	136
	vmovaps	%xmm6, 80(%rsp)
	.seh_savexmm	%xmm6, 80
	vmovaps	%xmm7, 96(%rsp)
	.seh_savexmm	%xmm7, 96
	vmovaps	%xmm8, 112(%rsp)
	.seh_savexmm	%xmm8, 112
	.seh_endprologue
	movl	$8, %edx
	xorl	%ebx, %ebx
	xorl	%edi, %edi
	movq	%rcx, %rsi
	movl	$22500, %ecx
	call	calloc
	movl	$4, %edx
	movl	$22500, %ecx
	movq	%rax, 152(%rsi)
	call	calloc
	movl	$4, %edx
	movl	$22500, %ecx
	movq	%rax, 160(%rsi)
	call	calloc
	vmovsd	.LC3(%rip), %xmm0
	movq	%rax, 168(%rsi)
	movq	120(%rsi), %rax
	movq	72(%rsi), %rcx
	movq	8(%rsi), %rdx
	vmovss	8(%rax), %xmm1
	vsubss	(%rax), %xmm1, %xmm1
	vunpcklps	%xmm1, %xmm1, %xmm1
	vcvtps2pd	%xmm1, %xmm1
	vmulsd	%xmm0, %xmm1, %xmm1
	vmovsd	%xmm1, 136(%rsi)
	vmovss	12(%rax), %xmm1
	vsubss	4(%rax), %xmm1, %xmm1
	movslq	(%rsi), %rax
	vunpcklps	%xmm1, %xmm1, %xmm1
	vcvtps2pd	%xmm1, %xmm1
	vmulsd	%xmm0, %xmm1, %xmm0
	leaq	(%rax,%rax,2), %r8
	leaq	(%rax,%r8,4), %r8
	vmovsd	%xmm0, 144(%rsi)
	call	memcpy
	movl	$8, %edx
	movl	$150, %ecx
	call	calloc
	movl	$8, %edx
	movl	$150, %ecx
	movq	%rax, 80(%rsi)
	call	calloc
	movl	$8, %edx
	movl	$150, %ecx
	movq	%rax, 96(%rsi)
	call	calloc
	movl	$8, %edx
	movl	$150, %ecx
	movq	%rax, 104(%rsi)
	call	calloc
	movl	$1, 72(%rsp)
	movq	%rax, 112(%rsi)
	movq	120(%rsi), %rax
	vmovss	(%rax), %xmm6
	vcvtps2pd	%xmm6, %xmm6
	vaddsd	136(%rsi), %xmm6, %xmm7
.L1299:
	movl	(%rsi), %r8d
	movslq	%ebx, %r14
	vmovddup	%xmm7, %xmm8
	leaq	(%r14,%r14,2), %rax
	vcvtpd2psx	%xmm8, %xmm8
	leaq	(%r14,%rax,4), %rcx
	addq	72(%rsi), %rcx
	subl	%ebx, %r8d
	addl	$1, %r8d
	js	.L1301
	movl	%r8d, %eax
	sarl	%eax
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r9
	leaq	(%rdx,%r9,4), %r9
	vmovss	5(%rcx,%r9), %xmm0
	xorl	%r9d, %r9d
	vcomiss	%xmm0, %xmm8
	jne	.L1304
	jmp	.L1302
	.p2align 4,,10
.L1394:
	leal	1(%rax), %r9d
	cmpl	%r9d, %r8d
	jl	.L1301
.L1312:
	leal	(%r8,%r9), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r10
	leaq	(%rdx,%r10,4), %r10
	vmovss	5(%rcx,%r10), %xmm0
	vcomiss	%xmm0, %xmm8
	je	.L1302
.L1304:
	vcomiss	%xmm0, %xmm8
	ja	.L1394
	leal	-1(%rax), %r8d
	cmpl	%r9d, %r8d
	jge	.L1312
.L1301:
	movl	%r8d, %eax
.L1305:
	leal	(%rbx,%rax), %edx
	addl	$1, %eax
	xorl	%r12d, %r12d
	leaq	0(,%rdi,8), %rbp
	movl	%edx, 44(%rsp)
	movl	%eax, %edx
	movq	%rbp, %rdi
	movl	%eax, 76(%rsp)
	movl	$1, %r13d
	call	_Z5ysortP5Pointj
	addq	80(%rsi), %rdi
	movl	$8, %edx
	movl	$150, %ecx
	call	calloc
	movl	$16, %edx
	movl	$150, %ecx
	movq	%rax, (%rdi)
	movq	%rbp, %rdi
	addq	96(%rsi), %rdi
	call	calloc
	movl	$16, %edx
	movl	$150, %ecx
	movq	%rax, (%rdi)
	movq	%rbp, %rdi
	addq	104(%rsi), %rdi
	call	calloc
	movl	$4, %edx
	movl	$150, %ecx
	movq	%rax, (%rdi)
	movq	%rbp, %rdi
	addq	112(%rsi), %rdi
	call	calloc
	vmovddup	%xmm6, %xmm6
	vcvtpd2psx	%xmm6, %xmm6
	movq	%rax, (%rdi)
	movq	120(%rsi), %rax
	vmovss	4(%rax), %xmm2
	vcvtps2pd	%xmm2, %xmm2
	vaddsd	144(%rsi), %xmm2, %xmm1
	.p2align 4,,10
.L1313:
	movl	44(%rsp), %r8d
	leaq	(%r14,%r14,2), %rax
	vmovddup	%xmm1, %xmm1
	leaq	(%r14,%rax,4), %r14
	vcvtpd2psx	%xmm1, %xmm1
	movq	%r14, %r10
	addq	72(%rsi), %r10
	subl	%ebx, %r8d
	addl	$1, %r8d
	js	.L1319
	movl	%r8d, %eax
	xorl	%r9d, %r9d
	sarl	%eax
	movslq	%eax, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	leaq	(%rcx,%rdx,4), %rdx
	vmovss	9(%r10,%rdx), %xmm0
	vcomiss	%xmm0, %xmm1
	jne	.L1318
	jmp	.L1316
	.p2align 4,,10
.L1395:
	leal	1(%rax), %r9d
	cmpl	%r9d, %r8d
	jl	.L1319
.L1326:
	leal	(%r8,%r9), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movslq	%eax, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	leaq	(%rcx,%rdx,4), %rdx
	vmovss	9(%r10,%rdx), %xmm0
	vcomiss	%xmm0, %xmm1
	je	.L1316
.L1318:
	vcomiss	%xmm0, %xmm1
	ja	.L1395
	leal	-1(%rax), %r8d
	cmpl	%r9d, %r8d
	jge	.L1326
.L1319:
	movq	96(%rsi), %rax
	movslq	%r12d, %rdi
	addl	%r8d, %ebx
	leal	1(%r8), %r15d
	movq	%rdi, %r10
	vmovddup	%xmm2, %xmm4
	salq	$4, %r10
	vcvtpd2psx	%xmm4, %xmm4
	movq	%r10, %rcx
	addq	(%rax,%rbp), %rcx
	testl	%r15d, %r15d
	vmovss	%xmm6, (%rcx)
	vmovss	%xmm4, 4(%rcx)
	vmovss	%xmm8, 8(%rcx)
	vmovss	%xmm1, 12(%rcx)
	jle	.L1396
	movq	112(%rsi), %rax
	leaq	0(,%rdi,8), %r12
	movslq	%r15d, %r8
	movq	%r12, %r11
	movq	%r8, %rcx
	movl	$13, %edx
	movq	%r10, 64(%rsp)
	movq	%r8, 48(%rsp)
	movq	(%rax,%rbp), %rax
	movl	%r15d, (%rax,%rdi,4)
	movq	80(%rsi), %rax
	addq	(%rax,%rbp), %r11
	movq	%r11, 56(%rsp)
	call	calloc
	movq	56(%rsp), %r11
	movq	%r14, %rdx
	movq	48(%rsp), %r8
	movq	%rax, (%r11)
	movq	80(%rsi), %rax
	addq	72(%rsi), %rdx
	movq	(%rax,%rbp), %rax
	movq	(%rax,%rdi,8), %rcx
	leaq	(%r8,%r8,2), %rax
	leaq	(%r8,%rax,4), %r8
	call	memcpy
	movq	80(%rsi), %rax
	movl	%r15d, %edx
	movq	(%rax,%rbp), %rax
	movq	(%rax,%rdi,8), %rcx
	call	_Z8ranksortP5Pointj
	movq	104(%rsi), %rax
	xorl	%r9d, %r9d
	movq	64(%rsp), %r10
	addq	(%rax,%rbp), %r10
	movq	80(%rsi), %rax
	movq	%r10, %r8
	movl	$0x4cbebc20, (%r10)
	movq	(%rax,%rbp), %rdx
	movl	$0x4cbebc20, 4(%r10)
	movl	$0xccbebc20, 8(%r10)
	movl	$0xccbebc20, 12(%r10)
	movq	(%rdx,%rdi,8), %rdx
	movq	%rdx, %rcx
	.p2align 4,,10
.L1338:
	testl	%r9d, %r9d
	je	.L1329
	vmovss	5(%rcx), %xmm0
	movq	%rcx, %r10
	subq	%rdx, %r10
	vcomiss	(%r8), %xmm0
	jae	.L1352
	vmovss	%xmm0, (%r8)
.L1352:
	vmovss	4(%r8), %xmm0
	vcomiss	9(%rcx), %xmm0
	jbe	.L1334
	movq	(%rax,%rbp), %r11
	movq	(%r11,%r12), %r11
	vmovss	9(%r11,%r10), %xmm0
	vmovss	%xmm0, 4(%r8)
.L1334:
	vmovss	5(%rcx), %xmm0
	vcomiss	8(%r8), %xmm0
	jbe	.L1333
	vmovss	%xmm0, 8(%r8)
.L1333:
	vmovss	9(%rcx), %xmm0
	vcomiss	12(%r8), %xmm0
	jbe	.L1336
.L1335:
	vmovss	%xmm0, 12(%r8)
.L1336:
	addl	$1, %r9d
	addq	$13, %rcx
	cmpl	%r15d, %r9d
	jne	.L1338
	movq	72(%rsi), %rdx
	movslq	%ebx, %r14
	leaq	(%r14,%r14,2), %rax
	leaq	(%r14,%rax,4), %rax
	leaq	(%rdx,%rax), %rcx
	vmovss	9(%rcx), %xmm0
	vunpcklps	%xmm0, %xmm0, %xmm0
	vcvtps2pd	%xmm0, %xmm1
	vcomisd	%xmm7, %xmm1
	jne	.L1328
	vcomiss	-4(%rdx,%rax), %xmm0
	jne	.L1340
	leaq	-17(%rdx,%rax), %rax
	vmovss	-4(%rcx), %xmm1
	jmp	.L1351
	.p2align 4,,10
.L1339:
	vmovaps	%xmm0, %xmm1
.L1351:
	vmovss	(%rax), %xmm0
	subl	$1, %ebx
	subq	$13, %rax
	vcomiss	%xmm1, %xmm0
	je	.L1339
.L1340:
	cmpl	$150, %r13d
	je	.L1397
.L1341:
	leal	1(%r13), %eax
	vmovsd	144(%rsi), %xmm1
	vcvtsi2sd	%r13d, %xmm2, %xmm2
	movq	120(%rsi), %rdx
	cmpl	$150, %eax
	vcvtsi2sd	%eax, %xmm3, %xmm3
	vmulsd	%xmm1, %xmm2, %xmm2
	vmovss	4(%rdx), %xmm0
	vmulsd	%xmm1, %xmm3, %xmm1
	vcvtps2pd	%xmm0, %xmm0
	vaddsd	%xmm0, %xmm2, %xmm2
	vaddsd	%xmm0, %xmm1, %xmm1
	je	.L1398
.L1314:
	movl	%r13d, %r12d
	movslq	%ebx, %r14
	movl	%eax, %r13d
	jmp	.L1313
	.p2align 4,,10
.L1396:
	movq	112(%rsi), %rax
	movq	(%rax,%rbp), %rax
	movl	$0, (%rax,%rdi,4)
	movq	80(%rsi), %rax
	movq	(%rax,%rbp), %rax
	movq	$0, (%rax,%rdi,8)
.L1328:
	addl	$1, %ebx
	cmpl	$150, %r13d
	jne	.L1341
.L1397:
	movl	76(%rsp), %eax
	testl	%eax, %eax
	jle	.L1342
	movslq	44(%rsp), %rax
	movq	72(%rsi), %rdx
	leaq	(%rax,%rax,2), %rcx
	leaq	(%rax,%rcx,4), %rax
	leaq	(%rdx,%rax), %rcx
	vmovss	5(%rcx), %xmm0
	vunpcklps	%xmm0, %xmm0, %xmm0
	vcvtps2pd	%xmm0, %xmm1
	vcomisd	%xmm7, %xmm1
	jne	.L1342
	vcomiss	-8(%rdx,%rax), %xmm0
	jne	.L1385
	leaq	-21(%rdx,%rax), %rax
	vmovss	-8(%rcx), %xmm1
	movl	44(%rsp), %ebx
	jmp	.L1347
.L1399:
	vmovaps	%xmm0, %xmm1
.L1347:
	vmovss	(%rax), %xmm0
	subl	$1, %ebx
	subq	$13, %rax
	vcomiss	%xmm1, %xmm0
	je	.L1399
.L1344:
	cmpl	$150, 72(%rsp)
	je	.L1400
.L1348:
	movl	72(%rsp), %eax
	vmovsd	136(%rsi), %xmm1
	movq	120(%rsi), %rdx
	vcvtsi2sd	%eax, %xmm6, %xmm6
	addl	$1, %eax
	vcvtsi2sd	%eax, %xmm2, %xmm2
	cmpl	$150, %eax
	vmovss	(%rdx), %xmm0
	vcvtps2pd	%xmm0, %xmm0
	vmulsd	%xmm1, %xmm6, %xmm6
	vmulsd	%xmm1, %xmm2, %xmm1
	vaddsd	%xmm0, %xmm6, %xmm6
	vaddsd	%xmm0, %xmm1, %xmm7
	je	.L1401
.L1300:
	movslq	72(%rsp), %rdi
	movl	%eax, 72(%rsp)
	jmp	.L1299
	.p2align 4,,10
.L1316:
	cmpl	%r8d, %eax
	jge	.L1391
	addq	$1, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	leaq	(%rcx,%rdx,4), %rdx
	vcomiss	9(%r10,%rdx), %xmm1
	jne	.L1391
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %rcx
	leaq	26(%rdx,%rcx,4), %rdx
	leaq	9(%r10,%rdx), %rdx
	jmp	.L1322
	.p2align 4,,10
.L1402:
	addq	$13, %rdx
	vcomiss	-13(%rdx), %xmm1
	jne	.L1391
.L1322:
	addl	$1, %eax
	cmpl	%r8d, %eax
	jne	.L1402
.L1391:
	movl	%eax, %r8d
	jmp	.L1319
.L1342:
	movl	44(%rsp), %ebx
	addl	$1, %ebx
	cmpl	$150, 72(%rsp)
	jne	.L1348
.L1400:
	vmovaps	80(%rsp), %xmm6
	vmovaps	96(%rsp), %xmm7
	vmovaps	112(%rsp), %xmm8
	addq	$136, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.p2align 4,,10
.L1302:
	cmpl	%eax, %r8d
	jle	.L1305
	addq	$1, %rdx
	leaq	(%rdx,%rdx,2), %r9
	leaq	(%rdx,%r9,4), %rdx
	vcomiss	5(%rcx,%rdx), %xmm8
	jne	.L1305
	movslq	%eax, %rdx
	leaq	(%rdx,%rdx,2), %r9
	leaq	26(%rdx,%r9,4), %rdx
	leaq	5(%rcx,%rdx), %rdx
	jmp	.L1308
.L1403:
	addq	$13, %rdx
	vcomiss	-13(%rdx), %xmm8
	jne	.L1305
.L1308:
	addl	$1, %eax
	cmpl	%r8d, %eax
	jne	.L1403
	jmp	.L1305
.L1329:
	vmovss	5(%rcx), %xmm0
	vmovss	%xmm0, (%r8)
	vmovss	9(%rcx), %xmm0
	vmovss	%xmm0, 4(%r8)
	vmovss	5(%rcx), %xmm0
	vmovss	%xmm0, 8(%r8)
	vmovss	9(%rcx), %xmm0
	jmp	.L1335
.L1385:
	movl	44(%rsp), %ebx
	jmp	.L1344
.L1398:
	vmovss	12(%rdx), %xmm1
	vcvtps2pd	%xmm1, %xmm1
	jmp	.L1314
.L1401:
	vmovss	8(%rdx), %xmm7
	vcvtps2pd	%xmm7, %xmm7
	jmp	.L1300
	.seh_endproc
	.p2align 4,,15
	.globl	_Z8freeGridP17GumpSearchContext
	.def	_Z8freeGridP17GumpSearchContext;	.scl	2;	.type	32;	.endef
	.seh_proc	_Z8freeGridP17GumpSearchContext
_Z8freeGridP17GumpSearchContext:
.LFB86:
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	xorl	%esi, %esi
	movq	%rcx, %rdi
	.p2align 4,,10
.L1405:
	xorl	%ebx, %ebx
	.p2align 4,,10
.L1408:
	movq	80(%rdi), %rax
	movq	(%rax,%rsi), %rax
	movq	(%rax,%rbx), %rcx
	addq	$8, %rbx
	call	free
	cmpq	$1200, %rbx
	jne	.L1408
	movq	80(%rdi), %rax
	movq	(%rax,%rsi), %rcx
	call	free
	movq	112(%rdi), %rax
	movq	(%rax,%rsi), %rcx
	call	free
	movq	104(%rdi), %rax
	movq	(%rax,%rsi), %rcx
	addq	$8, %rsi
	call	free
	cmpq	$1200, %rsi
	jne	.L1405
	movq	80(%rdi), %rcx
	call	free
	movq	112(%rdi), %rcx
	call	free
	movq	104(%rdi), %rcx
	call	free
	movq	120(%rdi), %rcx
	call	free
	movq	152(%rdi), %rcx
	call	free
	movq	160(%rdi), %rcx
	call	free
	movq	168(%rdi), %rcx
	addq	$32, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	jmp	free
	.seh_endproc
	.p2align 4,,15
	.globl	create
	.def	create;	.scl	2;	.type	32;	.endef
	.seh_proc	create
create:
.LFB87:
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$216, %rsp
	.seh_stackalloc	216
	vmovaps	%xmm6, 96(%rsp)
	.seh_savexmm	%xmm6, 96
	vmovaps	%xmm7, 112(%rsp)
	.seh_savexmm	%xmm7, 112
	vmovaps	%xmm8, 128(%rsp)
	.seh_savexmm	%xmm8, 128
	vmovaps	%xmm9, 144(%rsp)
	.seh_savexmm	%xmm9, 144
	vmovaps	%xmm10, 160(%rsp)
	.seh_savexmm	%xmm10, 160
	vmovaps	%xmm11, 176(%rsp)
	.seh_savexmm	%xmm11, 176
	vmovaps	%xmm12, 192(%rsp)
	.seh_savexmm	%xmm12, 192
	.seh_endprologue
	movq	%rcx, %rdi
	movl	$176, %ecx
	movq	%rdx, %rsi
	call	malloc
	subq	%rdi, %rsi
	movq	%rax, %rbx
	movabsq	$5675921253449092805, %rax
	imulq	%rax, %rsi
	testl	%esi, %esi
	movl	%esi, (%rbx)
	je	.L1411
	movslq	%esi, %rsi
	movl	$16, %ecx
	call	malloc
	movq	%rsi, %rcx
	movl	$13, %edx
	movq	%rax, 56(%rbx)
	call	calloc
	movq	%rsi, %rcx
	movl	$13, %edx
	movq	%rax, %r13
	movq	%rax, 8(%rbx)
	call	calloc
	movq	%rsi, %rcx
	movl	$13, %edx
	movq	%rax, %r12
	movq	%rax, 16(%rbx)
	call	calloc
	movq	%rsi, %rcx
	movl	$13, %edx
	movq	%rax, %rbp
	movq	%rax, 40(%rbx)
	call	calloc
	movq	%rdi, %rdx
	movq	%r13, %rcx
	movq	%rax, 72(%rbx)
	leaq	(%rsi,%rsi,2), %rax
	leaq	(%rsi,%rax,4), %rsi
	movq	%rsi, %r8
	call	memcpy
	movq	%rsi, %r8
	movq	%rdi, %rdx
	movq	%r12, %rcx
	call	memcpy
	movq	%rsi, %r8
	movq	%rdi, %rdx
	movq	%rbp, %rcx
	call	memcpy
	movq	8(%rbx), %rcx
	movl	(%rbx), %edx
	call	_Z5xsortP5Pointj
	movq	16(%rbx), %rcx
	movl	(%rbx), %edx
	call	_Z5ysortP5Pointj
	movl	(%rbx), %edx
	movq	40(%rbx), %rcx
	call	_Z8ranksortP5Pointj
	movl	$16, %ecx
	call	malloc
	movslq	(%rbx), %rdx
	movq	8(%rbx), %rcx
	movq	%rax, 120(%rbx)
	leaq	(%rdx,%rdx,2), %r8
	leaq	(%rdx,%r8,4), %rdx
	vmovss	18(%rcx), %xmm0
	vmovss	-21(%rcx,%rdx), %xmm2
	movq	16(%rbx), %rcx
	vmovss	%xmm0, (%rax)
	vsubss	%xmm0, %xmm2, %xmm0
	vmovss	%xmm2, 8(%rax)
	vmovss	-17(%rcx,%rdx), %xmm3
	vmovss	22(%rcx), %xmm1
	movq	%rbx, %rcx
	vmovss	%xmm3, 12(%rax)
	vmovss	%xmm1, 4(%rax)
	vsubss	%xmm1, %xmm3, %xmm1
	vmulss	%xmm0, %xmm1, %xmm0
	vunpcklps	%xmm0, %xmm0, %xmm0
	vcvtps2pd	%xmm0, %xmm4
	vmovsd	%xmm4, 128(%rbx)
	call	_Z9buildGridP17GumpSearchContext
	movq	120(%rbx), %rdi
	movl	$88, %ecx
	addl	$1, regions(%rip)
	call	malloc
	movl	$13, %edx
	movl	$500, %ecx
	movq	%rax, %rsi
	movq	%rdi, 24(%rax)
	movq	$0, 32(%rax)
	movq	$0, 40(%rax)
	movq	$0, 48(%rax)
	movq	$0, 56(%rax)
	movq	$0, 64(%rax)
	movq	$0, 72(%rax)
	movq	$0, 80(%rax)
	call	calloc
	vmovdqu	(%rdi), %xmm1
	movl	$500, %r8d
	movq	%rax, %r9
	movq	%rax, 8(%rsi)
	movq	%rbx, %rcx
	leaq	80(%rsp), %rdx
	vmovdqa	%xmm1, 80(%rsp)
	call	_Z12searchBinaryP17GumpSearchContext4RectiP5Point
	vmovss	8(%rdi), %xmm12
	movl	$16, %edx
	vmovss	(%rdi), %xmm11
	movl	$6, %ecx
	movl	%eax, (%rsi)
	vmovss	.LC1(%rip), %xmm6
	vaddss	%xmm11, %xmm12, %xmm8
	vmovss	12(%rdi), %xmm9
	vmovss	4(%rdi), %xmm10
	vmulss	%xmm6, %xmm8, %xmm8
	vaddss	%xmm10, %xmm9, %xmm7
	vmulss	%xmm6, %xmm7, %xmm7
	call	calloc
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	vmovss	%xmm8, 8(%rax)
	movq	%rax, %rdx
	movq	%rbx, %rcx
	vmovss	8(%rdi), %xmm0
	vmovss	%xmm10, 4(%rax)
	vmovss	%xmm11, (%rax)
	vaddss	%xmm11, %xmm8, %xmm11
	vmovss	%xmm0, 24(%rax)
	vmovss	4(%rdi), %xmm0
	vaddss	%xmm10, %xmm7, %xmm10
	vmovss	%xmm9, 12(%rax)
	vmovss	%xmm8, 16(%rax)
	vaddss	%xmm12, %xmm8, %xmm8
	vmulss	%xmm6, %xmm11, %xmm11
	vmovss	%xmm0, 20(%rax)
	vmovss	12(%rdi), %xmm0
	vmulss	%xmm6, %xmm10, %xmm10
	movq	%rax, 32(%rsi)
	vmovss	%xmm0, 28(%rax)
	vmovss	4(%rdi), %xmm0
	vmulss	%xmm6, %xmm8, %xmm8
	vmovss	%xmm11, 32(%rax)
	vmovss	%xmm0, 36(%rax)
	vmovss	12(%rdi), %xmm0
	vmovss	%xmm0, 44(%rax)
	vmovss	(%rdi), %xmm0
	vmovss	%xmm8, 40(%rax)
	vmovss	%xmm0, 48(%rax)
	vmovss	8(%rdi), %xmm0
	vmovss	%xmm0, 56(%rax)
	vmovss	4(%rdi), %xmm0
	vmovss	%xmm7, 60(%rax)
	vmovss	%xmm0, 52(%rax)
	vmovss	(%rdi), %xmm0
	vmovss	%xmm0, 64(%rax)
	vmovss	8(%rdi), %xmm0
	vmovss	%xmm7, 68(%rax)
	vaddss	%xmm9, %xmm7, %xmm7
	vmovss	%xmm0, 72(%rax)
	vmovss	12(%rdi), %xmm0
	vmulss	%xmm6, %xmm7, %xmm7
	vmovss	%xmm0, 76(%rax)
	vmovss	(%rdi), %xmm0
	vmovss	%xmm0, 80(%rax)
	vmovss	8(%rdi), %xmm0
	vmovss	%xmm10, 84(%rax)
	vmovss	%xmm0, 88(%rax)
	vmovss	%xmm7, 92(%rax)
	movl	$2, 64(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	movq	$0, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movq	%rax, 40(%rsi)
	movq	32(%rsi), %rax
	movq	%rbx, %rcx
	movl	$2, 64(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	leaq	16(%rax), %rdx
	movq	$0, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movq	40(%rsi), %rdx
	xorl	%r9d, %r9d
	movq	%rax, 48(%rsi)
	movq	32(%rsi), %rdi
	movq	%rbx, %rcx
	movq	48(%rdx), %r8
	movl	$2, 64(%rsp)
	movq	$0, 56(%rsp)
	leaq	32(%rdi), %rdx
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	movq	40(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movq	%rbx, %rcx
	movq	64(%rax), %r9
	movq	%rax, 56(%rsi)
	movq	40(%rsi), %rax
	movq	64(%rax), %r8
	movq	32(%rsi), %rax
	movl	$2, 64(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	leaq	48(%rax), %rdx
	movq	48(%rsi), %rax
	movq	64(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movq	%rbx, %rcx
	movq	%rax, 64(%rsi)
	movq	56(%rsi), %rax
	movq	72(%rax), %r9
	movq	40(%rsi), %rax
	movq	72(%rax), %r8
	movq	32(%rsi), %rax
	movl	$2, 64(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 40(%rsp)
	leaq	64(%rax), %rdx
	movq	48(%rsi), %rax
	movq	72(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movq	56(%rsi), %rdx
	movq	%rbx, %rcx
	movq	%rax, 72(%rsi)
	movq	32(%rsi), %rdi
	movq	80(%rdx), %r9
	movq	40(%rsi), %rdx
	movq	80(%rdx), %r8
	movl	$2, 64(%rsp)
	leaq	80(%rdi), %rdx
	movq	64(%rax), %rax
	movq	$0, 48(%rsp)
	movq	%rax, 56(%rsp)
	movq	64(%rsi), %rax
	movq	72(%rax), %rax
	movq	%rax, 40(%rsp)
	movq	48(%rsi), %rax
	movq	80(%rax), %rax
	movq	%rax, 32(%rsp)
	call	_Z11buildRegionP17GumpSearchContextP4RectP6RegionS4_S4_S4_S4_S4_i
	movl	$1, %edx
	movl	$500, %ecx
	movq	%rax, 80(%rsi)
	movq	%rsi, 48(%rbx)
	call	calloc
	movq	72(%rbx), %rcx
	movq	%rax, 64(%rbx)
	call	free
	movq	40(%rbx), %rcx
	call	free
	movq	48(%rbx), %rcx
	movl	$1, %r9d
	movl	$1, 48(%rsp)
	movl	$1, %r8d
	movl	$1, %edx
	movl	$1, 40(%rsp)
	movl	$1, 32(%rsp)
	call	_Z13convertRegionP6Regionbbbbbb
	nop
.L1411:
	vmovaps	96(%rsp), %xmm6
	movq	%rbx, %rax
	vmovaps	112(%rsp), %xmm7
	vmovaps	128(%rsp), %xmm8
	vmovaps	144(%rsp), %xmm9
	vmovaps	160(%rsp), %xmm10
	vmovaps	176(%rsp), %xmm11
	vmovaps	192(%rsp), %xmm12
	addq	$216, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	search
	.def	search;	.scl	2;	.type	32;	.endef
	.seh_proc	search
search:
.LFB88:
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	xorl	%eax, %eax
	vmovdqu	(%rdx), %xmm1
	movl	(%rcx), %edx
	testl	%edx, %edx
	je	.L1415
	leaq	32(%rsp), %rdx
	vmovdqa	%xmm1, 32(%rsp)
	call	_Z14searchGumptionP17GumpSearchContext4RectiP5Point
.L1415:
	addq	$56, %rsp
	ret
	.seh_endproc
	.p2align 4,,15
	.globl	destroy
	.def	destroy;	.scl	2;	.type	32;	.endef
	.seh_proc	destroy
destroy:
.LFB89:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	movl	(%rcx), %eax
	movq	%rcx, %rbx
	testl	%eax, %eax
	je	.L1420
	movq	8(%rcx), %rcx
	call	free
	movq	16(%rbx), %rcx
	call	free
	movq	56(%rbx), %rcx
	call	free
	movq	48(%rbx), %rcx
	movl	$1, %r9d
	movl	$1, %r8d
	movl	$1, %edx
	movl	$1, 48(%rsp)
	movl	$1, 40(%rsp)
	movl	$1, 32(%rsp)
	call	_Z10freeRegionP6Regionbbbbbb
	movq	64(%rbx), %rcx
	call	free
	movq	%rbx, %rcx
	call	_Z8freeGridP17GumpSearchContext
.L1420:
	movq	%rbx, %rcx
	call	free
	xorl	%eax, %eax
	addq	$64, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.globl	regions
	.bss
	.align 32
regions:
	.space 4
	.globl	nbin
	.align 4
nbin:
	.space 4
	.globl	ngrid
	.align 4
ngrid:
	.space 4
	.globl	hitchecks
	.align 4
hitchecks:
	.space 4
	.section .rdata,"dr"
	.align 4
.LC0:
	.long	1061158912
	.align 4
.LC1:
	.long	1056964608
	.align 8
.LC3:
	.long	3035110223
	.long	1065045633
	.ident	"GCC: (GNU) 4.8.3"
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	calloc;	.scl	2;	.type	32;	.endef
	.def	memcpy;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
	.section .drectve
	.ascii " -export:\"destroy\""
	.ascii " -export:\"search\""
	.ascii " -export:\"create\""
