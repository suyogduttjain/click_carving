Click Carving: Segmenting Objects in Videos with Point Clicks v1.0
================================================================================

Suyog Jain and Kristen Grauman
suyog@cs.utexas.edu

Please go through run_driver.m to see how to run this code.

Only parameter that you need to adjust is num_proposals, which defines the number of proposals to generate for each frame.

This is a image only version of the algorithm, hence we only use the appearance information to generate the propoasls.

The MCG code is included in the external_libs folder, it was compiled on a 64-bit linux machine, you might need to recompile it for your purpose. 

==========
Interface
==========
Please check the video demo on the wesbite for a quick overview of the interface:
http://vision.cs.utexas.edu/projects/clickcarving/

1) Please use left mouse click on the ***boundaries*** of the object of interest. This will put positive clicks.

2) This version also supports negative clicks. Please use right click to place negative clicks. Negative clicks can be placed anywhere, including the ***interiors***.

The positive clicks are shown in green, the negative ones are shown in red.

After each click, you should see an updated reranking. 


[1] Suyog Jain, Kristen Grauman, “Click Carving: Segmenting Objects in Video with Point Clicks”, Fourth AAAI Conference on Human Computation and Crowdsourcing (HCOMP), 2016. 


