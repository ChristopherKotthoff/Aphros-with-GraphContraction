# mesh size
m ?= 32 32 32
# block size
bs ?= 16 16 16
# number of tasks
np ?= 1
# time limit in minutes
tl ?= 60
# number of threads for openmp
OMP_NUM_THREADS ?= 1

hook ?=

error:
	@echo Error: no target specified.
	@make -s help
	@exit 2

help:
	@echo Available targets:
	@echo - cleanrun: cleanall, run
	@echo - run: start in foreground
	@echo - submit: submit job or start in background
	@echo - clean: remove logs, generated conf
	@echo - cleandat: remove output data
	@echo - cleanall: clean, cleandat


cleanrun: cleanall run

run: conf
	LD_PRELOAD="$(hook):$${LD_PRELOAD}" ap.run ap.mfer --version --verbose

submit: conf
	LD_PRELOAD="$(hook):$${LD_PRELOAD}" ap.submit ap.mfer --version --verbose

kill:
	ap.kill

add.conf:
	touch $@

base.conf:
	ap.create_base_conf

a.conf:
	ap.create_a_conf

# XXX tl,np,mesh.conf may be generated by a prerequisite of conf
conf: a.conf base.conf add.conf std.conf
	@test -f np || ( c='echo $(np) > np' && echo "$$c" && eval "$$c" )
	@test -f tl || ( c='echo $(tl) > tl' && echo "$$c" && eval "$$c" )
	@test -f mesh.conf || ( c='ap.part $(m) $(bs) $(np) > mesh.conf' && echo "$$c" && eval "$$c" )

clean::
	rm -vf job.id.last job.status arg job.id
	rm -vf mesh.conf base.conf a.conf par.conf np tl

cleandat::
	rm -vf *_*.{xmf,h5,raw,vts,vtk,csv} p.pvd
	rm -vf {vx,vy,vz,p,vf,cl,cls,div,omm}_*.dat
	rm -vf bc.vtk bc_groups.dat eb.vtk
	rm -vf stat.dat stat_summary out out.conf
	rm -vf lsf.o* slurm*.out
	rm -vf core.*

cleanall: clean cleandat

.PHONY: error cleanrun run submit clean cleandat base conf kill help