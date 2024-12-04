FC = nvfortran
FCFLAGS = -g -Minfo=all
FCFLAGS_OMP = -mp=gpu
FCFLAGS_ACC = -acc

all: prog_omp prog_acc

#---

prog_omp: omp/prog.o omp/test_mod.o | omp
	$(FC) $(FCFLAGS) $(FCFLAGS_OMP) -o $@ $^

omp/prog.o: prog.f90 omp/test_mod.mod | omp
	cd omp && $(FC) $(FCFLAGS) $(FCFLAGS_OMP) -c ../$<

omp/test_mod.mod: omp/test_mod.o
omp/test_mod.o: test_mod.f90 | omp
	cd omp && $(FC) $(FCFLAGS) $(FCFLAGS_OMP) -c ../$<

omp:
	mkdir -p omp

#---

prog_acc: acc/prog.o acc/test_mod.o | acc
	$(FC) $(FCFLAGS) $(FCFLAGS_ACC) -o $@ $^

acc/prog.o: prog.f90 acc/test_mod.mod | acc
	cd acc && $(FC) $(FCFLAGS) $(FCFLAGS_ACC) -c ../$<

acc/test_mod.mod: acc/test_mod.o
acc/test_mod.o: test_mod.f90 | acc
	cd acc && $(FC) $(FCFLAGS) $(FCFLAGS_ACC) -c ../$<

acc:
	mkdir -p acc

#---

clean:
	rm -f prog_omp prog_acc
	rm -rf omp acc
