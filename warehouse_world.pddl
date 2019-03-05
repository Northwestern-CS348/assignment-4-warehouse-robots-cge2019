(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
    (:action robotMove
      :parameters (?rob - robot ?a - location ?b - location)
      :precondition (and 
                      (at ?rob ?a) 
                      (no-robot ?b)
                      (connected ?a ?b)
                    )
      :effect (and 
                  (no-robot ?a)
                  (not (no-robot ?b)) 
                  (not (at ?rob ?a))
                  (at ?rob ?b) 
              )
   )
    (:action moveItemFromPalletteToShipment
      :parameters (?item - saleitem ?s - shipment ?o - order ?l - location ?p - pallette)
      :precondition (and 
      					(at ?p ?l) 
      					(orders ?o ?item)
      					(contains ?p ?item) 
      					(packing-at ?s ?l) 
      					(not (complete ?s))
      					(ships ?s ?o) 
  					)
      :effect (and 
                (includes ?s ?item) 
                (not (contains ?p ?item))
              )
   )
   
   (:action robotMoveWithPallette
      :parameters (?rob - robot ?a - location ?b - location ?p - pallette)
      :precondition (and (no-robot ?b) (at ?rob ?a) (at ?p ?a) (connected ?a ?b) (no-pallette ?b))
      :effect   (and 
                  (at ?rob ?b) 
                  (at ?p ?b) 

                  (no-robot ?a) 
                  (not (no-robot ?b))

                   
                  (not (at ?rob ?a))
                  (not (at ?p ?a)) 

                  (no-pallette ?a) 
                  (not (no-pallette ?b))
                   
                )
   )    
   

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (ships ?s ?o) (packing-at ?s ?l)(not (complete ?s)))
      :effect (and 
                  (complete ?s) 
                  (available ?l)
              )
   )

)
