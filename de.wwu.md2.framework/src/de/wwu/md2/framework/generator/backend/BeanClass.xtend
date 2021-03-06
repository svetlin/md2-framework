package de.wwu.md2.framework.generator.backend

import de.wwu.md2.framework.mD2.Entity
import de.wwu.md2.framework.mD2.ModelElement
import de.wwu.md2.framework.mD2.ReferencedModelType
import de.wwu.md2.framework.mD2.RemoteValidator
import java.util.Collection

import static extension de.wwu.md2.framework.util.IterableExtensions.*

class BeanClass {
	
	def static createEntityBean(String basePackageName, Entity entity) '''
		package «basePackageName».beans;
		
		import java.util.ArrayList;
		import java.util.List;
		
		import javax.ejb.Stateless;
		import javax.persistence.EntityManager;
		import javax.persistence.PersistenceContext;
		
		import «basePackageName».Utils;
		import «basePackageName».datatypes.InternalIdWrapper;
		import «basePackageName».models.«entity.name.toFirstUpper»;
		
		@Stateless
		public class «entity.name.toFirstUpper»Bean {
			
			@PersistenceContext(unitName = "«basePackageName»")
		    EntityManager em;
			
			/*
			 * TODO Implement backend logic for the «entity.name.toFirstUpper» entity here.
			 * These bean methods should be accessed from the web services.
			 */
			
			
			/*
			 * Default logic to get and set «entity.name.toFirstUpper» entities
			 */
			
			public List<«entity.name.toFirstUpper»> getAll«entity.name.toFirstUpper»s(String filter) {
				List<«entity.name.toFirstUpper»> result = em.createQuery("SELECT t FROM «entity.name.toFirstUpper» t " + Utils.buildWhereParameterFromFilterString(filter), «entity.name.toFirstUpper».class)
					.getResultList();
				
				return result;
			}
			
			public «entity.name.toFirstUpper» getFirst«entity.name.toFirstUpper»(String filter) {
				List<«entity.name.toFirstUpper»> result = em.createQuery("SELECT t FROM «entity.name.toFirstUpper» t " + Utils.buildWhereParameterFromFilterString(filter), «entity.name.toFirstUpper».class)
					.setMaxResults(1)
					.getResultList();
				
				return result.isEmpty() ? null : result.get(0);
			}
			
			public List<InternalIdWrapper> put«entity.name.toFirstUpper»s(List<«entity.name.toFirstUpper»> «entity.name.toFirstLower»s) {
				ArrayList<InternalIdWrapper> ids = new ArrayList<InternalIdWrapper>();
				
				for(«entity.name.toFirstUpper» «entity.name.toFirstLower» : «entity.name.toFirstLower»s) {
					«entity.name.toFirstLower» = em.merge(«entity.name.toFirstLower»);
										
					ids.add(new InternalIdWrapper(«entity.name.toFirstLower».getInternal__id()));
				}
				return ids;
			}
			
			public boolean delete«entity.name.toFirstUpper»(String id) {
				«entity.name.toFirstUpper» «entity.name.toFirstLower» = em.find(«entity.name.toFirstUpper».class, Integer.parseInt(id));
				
				if(«entity.name.toFirstLower» != null) {
					em.remove(«entity.name.toFirstLower»);
					return true;
				} else {
					return false;
				}
			}
		}
	'''
	
	def static createRemoteValidationBean(String basePackageName, Collection<ModelElement> affectedEntities, Collection<RemoteValidator> remoteValidators) '''
		package «basePackageName».beans;
		
		import javax.ejb.Stateless;
		import javax.persistence.EntityManager;
		import javax.persistence.PersistenceContext;
		
		import «basePackageName».datatypes.ValidationResult;
		«FOR entity : affectedEntities»
			import «basePackageName».models.«entity.name.toFirstUpper»;
		«ENDFOR»
		
		/**
		 * Implement backend logic for the remote validators here.
		 * These bean methods should be accessed from the RemoteValidation web service.
		 */
		@Stateless
		public class RemoteValidationBean {
			
			@PersistenceContext(unitName = "«basePackageName»")
		    EntityManager em;
			
			
			/*
			 * Stubs: Implement remote validators here
			 */
			
			«FOR validator : remoteValidators»
				«IF validator.contentProvider != null && validator.contentProvider.type instanceof ReferencedModelType»
					public ValidationResult validate«validator.name.toFirstUpper»(«(validator.contentProvider.type as ReferencedModelType).entity.name.toFirstUpper» «(validator.contentProvider.type as ReferencedModelType).entity.name.toFirstLower») {
						
						// TODO implement
						
						return new ValidationResult(true);
					}
					
				«ELSE /* based on attributes */»
					public ValidationResult validate«validator.name.toFirstUpper»(«validator.provideAttributes.joinWithIdx("", ", ", "", [s, i | '''String param«i + 1»'''])») {
						
						// TODO implement
						
						return new ValidationResult(true);
					}
					
				«ENDIF»
			«ENDFOR»
		}
	'''
}
